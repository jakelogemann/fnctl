{
  description = "virtual machine";

  inputs.fnctl = {
    url = "github:fnctl/fnctl.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";

  outputs = inputs @ {
    self,
    nixpkgs,
    fnctl,
    ...
  }: let
    inherit (fnctl.lib) mkSystem pkgsForSystem';
    system = "aarch64-linux";
    hostName = "pvm";
  in {
    # I prefer the alejandra formatter, similar to FnCtl.
    inherit (fnctl.outputs) formatter;

    devShells.${system}.default = with (pkgsForSystem' system);
      mkShell {
        name = hostName;
        buildInputs = [
          gitMinimal
          deadnix
          nix
          alejandra
          (writeShellScriptBin "nixos-rebuild"
            "exec ${lib.getExe nixos-rebuild} --install-bootloader --flake '${self}#${hostName}' \"$@\"")
          (writeShellScriptBin "build" "exec nixos-rebuild build \"$@\"")
          (writeShellScriptBin "switch" "exec sudo nixos-rebuild switch \"$@\"")
        ];
      };

    nixConfig = {
      bash-prompt = "pvm";
      bash-prompt-suffix = "> ";
      flake-registry = ./flake.registry.json;
    };

    nixosConfigurations.${hostName} = mkSystem {
      inherit system hostName;
      withDocs = true;
      modules = [
        ./system.nix
        ({lib, ...}: {
          disabledModules = ["virtualisation/parallels-guest.nix"];
          imports = [fnctl.nixosModules.parallels];
          nixpkgs.overlays = lib.mkForce [fnctl.overlays.default];
          nix.registry = lib.mkForce {
            fnctl.flake = fnctl;
            nixpkgs.flake = nixpkgs;
            ${hostName}.flake = self;
          };
        })
      ];
    };
  };
}
