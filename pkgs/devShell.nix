{ callPackage, mkShell, pkgs, ... }@args: mkShell { 
  packages = callPackage ./osdk/pkgs.nix {}; 
}
