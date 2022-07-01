self: system:
with (self.lib.pkgsForSystem' system);
  mkShell {
    name = "rust development";
    buildInputs = [
      fnctl.devShell-common
      rustup
    ];
  }
