self: system:
with (self.lib.pkgsForSystem' system);
  mkShell {
    name = "go development";
    buildInputs = [
      fnctl.devShell-common
      go-protobuf
      go_1_18
    ];
  }
