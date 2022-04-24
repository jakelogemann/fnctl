# Impure import is used for ad-hoc inclusion. Given only nixpkgs, it
# bootstraps all of the functions.
{ pkgs ? (import <nixpkgs> {}), lib ? pkgs.lib, ... }:

let
  pkgWithContext = (import ./pkgWithContext.nix { inherit pkgs lib; });
  dirNixFiles = (pkgWithContext ./dirNixFiles.nix {});
  srcDir = ./.;

  # Fetches the list of Nix files in the ./src directory, strips the
  # ".nix" file extension, and then calls the imported package with the
  # context defined above.
  nixLoadAttrs = lib.mapAttrs' (oldName: oldValue: {
    name  = lib.removeSuffix ".nix" oldName;
    value = (pkgWithContext oldValue {});
  });

  nixFunctions = lib.filterAttrs (n: v: n != "impure.nix" && n != "default.nix") (dirNixFiles srcDir);

in nixLoadAttrs nixFunctions
