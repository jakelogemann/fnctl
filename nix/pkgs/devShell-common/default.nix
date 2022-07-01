{
  pkgs,
  symlinkJoin,
  ...
}:
symlinkJoin {
  name = "devShell-common";
  paths = with pkgs;
    [
      bat
      gh
      gitMinimal
      jq
      nix-direnv
      pass
      ripgrep
    ]
    ++ (lib.mapAttrsToList (i: o: writeShellScriptBin i "exec ${o} \"$@\"") {
      gs = "git status";
      gd = "git diff";
      grs = "git reset";
      grb = "git rebase";
      gco = "git checkout";
      gl = "git log";
      ll = "ls -lAh";
      l1 = "ls -1A";
    });
}
