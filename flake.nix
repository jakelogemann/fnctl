{
  description = "fnctl";

  inputs = {
    nix-filter.url = "github:numtide/nix-filter";
    hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "nixpkgs/nixos-22.05";
    templates.url = "github:nixos/templates";
    utils.inputs.nixpkgs.follows = "nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: rec {
    apps = lib.loadAppDir ./nix/apps;
    checks = lib.loadChecks ./nix/checks;
    devShells = lib.loadDevShells ./nix/devShells;
    formatter = lib.eachSystemMap (system: (lib.pkgsForSystem' system).alejandra);
    lib = import ./nix/lib self;
    nixosConfigurations = lib.loadOSConfigs ./nix/os-configs;
    nixosModules = lib.loadOSModules ./nix/modules;
    overlays = lib.loadOverlays ./nix/overlays;
    packages = lib.loadPackages ./nix/pkgs;
    templates = lib.loadTemplates ./nix/templates;
  };
}
