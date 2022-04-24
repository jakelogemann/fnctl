self: system:
with (self.lib.pkgsForSystem' system); {
  AstroNvim = callPackage ./AstroNvim {};
  fnctl-icons = callPackage ./fnctl-icons {};
  devShell-common = callPackage ./devShell-common {};
}
