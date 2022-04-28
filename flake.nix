{
  description = "fnctlOS";

  inputs = {
    stable           = { url = "nixpkgs/nixos-21.11"; };
    unstable         = { url = "nixpkgs/nixos-unstable"; };
    /* hydra         = { url = "github:nixos/hydra"; }; */
    /* nixops        = { url = "github:nixos/nixops"; inputs.nixpkgs.follows = "stable"; }; */
    nixos-hardware   = { url = "github:nixos/nixos-hardware"; };
    home-manager     = { url = "github:nix-community/home-manager";  inputs.nixpkgs.follows = "stable"; };
    nixos-generators = { url = "github:nix-community/nixos-generators"; inputs.nixpkgs.follows = "stable"; };
  };

  outputs = { self, stable, unstable, home-manager, nixos-generators, ... }@specialArgs: rec {

    /* Overlay
    **  This determines what should be "overlay"-ed on top of "pkgs" when this
    **  flake is used. The spec allows for multiple overlays, I find that
    **  confusing, so for now only one (thus the names final/prev instead of self/super). */
    overlays.default = (final: prev: let inherit (prev) system; in { 
      unstable = unstable.legacyPackages.${system};
      home-manager = home-manager.packages.${system};
      nixos-generators = nixos-generators.packages.${system}.nixos-generators;
      jlogemann = {
        vim = self.packages.${system}.vim;
        installer = self.lib.nixosGenerateAll { inherit system; modules = [ ./configs/installer.nix ]; };
      };
    });

    /* Library [Functions]
    **  These are small, "discrete", helper functions which are used throughout
    **  this Nix environment. They should not depend on any packages, instead
    **  relying only on lib & builtins. */
    lib = with stable.lib; rec {
      supportedSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
      forEachSupportedSystem = f: genAttrs supportedSystems (system: f system);
      mkEnabledOption = import ./lib/mkEnabledOption.nix;
      pkgsForSystem = system: import stable { 
        inherit system;
        config.allowUnfree = true; 
        overlays = [(final: prev: with final; { 
          home-manager = home-manager.legacyPackages.${system};
          unstable = unstable.legacyPackages.${system};
        })];
      };

      callPackage = system: (callPackageWith (specialArgs // (pkgsForSystem system)));

      mkModuleList = ext: concatLists [ 
        [({ config, lib, pkgs, ... }: { 
            nixpkgs.overlays = builtins.attrValues self.overlays; 
            nixpkgs.config.allowUnfree = true; 
            nix.package = lib.mkForce pkgs.nixUnstable;
        })]
        (builtins.attrValues self.nixosModules)
        ext
      ];
    
      nixosGenerate = { system, format ? "iso", pkgs ? (pkgsForSystem system), modules ? [], ... }: nixos-generators.nixosGenerate { 
        inherit pkgs format; modules = mkModuleList modules;
      };

      nixosGenerateAll = { 
        system, pkgs ? (pkgsForSystem system), modules ? [], formats ? ["iso" "install-iso" "gce" "do" "vm"], ... 
      }: (builtins.listToAttrs (builtins.map 
        (format: { name = format; value = nixosGenerate { inherit format system pkgs modules; }; }) formats));

      mkSystem = { system, modules, ... }: nixosSystem { 
        inherit system specialArgs; 
        modules = mkModuleList modules;
      };
    };

    /* NOTE: packages are per system type. */ 
    packages = with self.lib; forEachSupportedSystem (system: {
      devShell = (callPackage system) ./pkgs/devShell.nix {};
      vim      = (callPackage system) ./pkgs/jlogemann/vim/default.nix {};
    });
        
    apps = /* all apps exposed; per system. invoke with `nix run .#nvim` */
    (self.lib.forEachSupportedSystem (system: with self.packages.${system}; rec {
      vim  = { type = "app"; program = "${nvim}/bin/vim"; };
      default = vim;
    }));

    /* invoke with argumentless `nix run` */
    defaultApp = self.lib.forEachSupportedSystem (system: self.apps."${system}".default);

    devShell = /* invoke with: `nix develop` */
    self.lib.forEachSupportedSystem (sys: self.packages.${sys}.devShell);

    nixosModules = import ./modules/default.nix;

    nixosConfigurations.installer = self.lib.mkSystem {
      system = "x86_64-linux";
      modules = [ ./configs/installer.nix ];
    };

    nixosConfigurations.vm-aarch64 = self.lib.mkSystem {
      system = "aarch64-linux";
      modules = [ ./configs/vm-aarch64.nix ];
    };
  };
}
