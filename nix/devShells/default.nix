self: system:
with (self.lib.pkgsForSystem' system); let
  repl = writeText "repl.nix" ''
    {
      dir ? builtins.getEnv "PWD",
      flake ? builtins.getFlake dir,
      system ? builtins.currentSystem,
      inputs ? flake.inputs,
      outputs ? flake.outputs,
      lib ? flake.outputs.lib,
      pkgs ? lib.pkgsForSystem' system,
      ...
    }: ({inherit pkgs flake inputs outputs lib;} // inputs // outputs)
  '';
in
  mkShell {
    name = "fnctl";
    buildInputs = [
        (writeShellScriptBin "fmt" "exec alejandra -q \"$@\"")
        (writeShellScriptBin "repl" "exec nix repl \"$@\" ${repl}")
        alejandra
        fnctl.devShell-common
        nix
    ];
  }
