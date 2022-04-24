self: system:
with (self.lib.pkgsForSystem' system);
  mkShell {
    name = "k8s";
    buildInputs = [
      fnctl.devShell-common
      kubectl
    ];
  }
