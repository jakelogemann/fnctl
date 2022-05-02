self: super: 
let 
  inherit (self) callPackage;
  inherit (super) system; 
in {
  fnctl = {
    vim = callPackage ./vim/default.nix {};
    devShell = callPackage ./devShell.nix {};
  };
}