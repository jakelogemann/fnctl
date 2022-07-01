{
  description = "terraform";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/22.05";
  inputs.fnctl = {
    url = "github:fnctl/fnctl.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    fnctl,
    nixpkgs,
  }:
    with fnctl.lib; {
      inherit (fnctl.outputs) formatter;
      devShells = eachSystemMap (system:
        with (pkgsForSystem' system); {
          default = mkShell {
            buildInputs = [
              jq
              (writeShellScriptBin "tf" "exec terraform \"$@\"")
              (writeShellScriptBin "list-providers" "echo ${lib.concatStringsSep " " (builtins.attrNames terraform-providers)}")
              (terraform.withPlugins (p:
                with p; let
                  officialPlugins = [archive template external http random dns null local time tls cloudinit];
                  vendorPlugins = [
                    digitalocean
                    cloudflare
                    # github
                    # vault
                  ];
                in
                  officialPlugins ++ vendorPlugins))
            ];
          };
        });
    };
}
