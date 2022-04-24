self: with builtins; with self.inputs.nixpkgs.lib; let
  validNixFile = path': type': !hasPrefix "." path' && !hasPrefix "_" path' && hasSuffix ".nix" path' && type' == "regular";
  filter = path': type': (validNixFile path' type') || type' == "directory";
  namesFromContents = contents: map (f: replaceStrings [".nix"] [""] (toString f)) (attrNames (readDir contents));
in rec {
  callPackage = system: (callPackageWith (inputs // (pkgsForSystem' system)));
  callPackageForEachSupportedSystem = path: ctx: eachSystem (s: callPackageForSystem s path ctx);
  callPackageForSystem = system: path: ctx: (callPackage system) path ctx;
  callPackages = system: (callPackagesWith (inputs // (pkgsForSystem' system)));
  constants = importTOML ./constants.toml;
  eachSystem = eachDefaultSystem;
  eachSystemMap = eachDefaultSystemMap;
  importForEachSupportedSystem = path: ctx: eachSystem (system: importForSystem system ctx);
  importForSystem = system: path: ctx: import path (self.inputs // {inherit self system;} // ctx);
  inherit mkIf mapAttrs hasSuffix concatStringsSep;
  inherit (self.inputs.utils.lib) eachDefaultSystem eachDefaultSystemMap defaultSystems mkApp;
  mkCSV = concatStringsSep ",";
  mkSystem = import ./mkSystem.nix self;
  nixpkgs = self.inputs.nixpkgs.lib;
  supportedSystems = defaultSystems;

  pkgsForSystem = system: self.inputs.nixpkgs.legacyPackages.${system};
  pkgsForSystem' = system:
    import self.inputs.nixpkgs {
      inherit system;
      overlays = [self.overlays.default];
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
    };

  smartPath = basePath: name:
    if pathExists "${basePath}/${name}.nix"
    then "${basePath}/${name}.nix"
    else if pathExists "${basePath}/${name}/default.nix"
    then "${basePath}/${name}/default.nix"
    else if pathExists "${basePath}/${name}/${name}.nix"
    then "${basePath}/${name}/${name}/${name}.nix"
    else null;

  smartImport = basePath: name: let
    finalPath = smartPath basePath name;
  in
    if finalPath == null
    then throw "cannot import ${name} from ${basePath}"
    else import finalPath;

  importWithSelf = path: let
    contents = builtins.path {inherit filter path;};
  in
    listToAttrs (builtins.map (name: {
        inherit name;
        value = (smartImport contents name) self;
      })
      (namesFromContents contents));

  importWithSelfAndSystem = path: let
    contents = builtins.path {inherit filter path;};
    getApps = system:
      listToAttrs (builtins.map (name: {
          inherit name;
          value = (smartImport contents name) self system;
        })
        (namesFromContents contents));
  in
    eachSystemMap getApps;

  loadOverlays = importWithSelf;
  loadOSConfigs = importWithSelf;
  loadAppDir = importWithSelfAndSystem;
  loadChecks = importWithSelfAndSystem;
  loadDevShells = importWithSelfAndSystem;

  loadTemplates = path: let
    contents = builtins.path {inherit filter path;};
    # get all sub-directory names from the path.
    names = attrNames (filterAttrs (name: ty: ty == "directory") (readDir contents));
  in
    foldl' (acc: name:
      acc
      // {
        "${name}" = let
          dir = "${contents}/${name}";
        in {
          path = dir;
          description = (import "${dir}/flake.nix").description;
        };
      }) {}
    names;

  loadOSModules = path: let
    contents = builtins.path {inherit filter path;};
    names = attrNames (filterAttrs (name: ty: ty == "directory") (readDir contents));
  in
    foldl' (acc: name: acc // {"${name}" = smartImport contents name;}) {} names;

  loadPackages = path:
    eachSystemMap (system: import "${path}/default.nix" self system);
}
