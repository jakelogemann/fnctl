self: system:
with (self.lib.pkgsForSystem' system);
  mkShell {
    name = "networking";
    buildInputs = [
      fnctl.devShell-common
      mtr
      dogdns
    ];
  }
