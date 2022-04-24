{ pkgs, escapeShellArg, mapAttrsToList, runCommand, writeScript }:
/*
* Wrapping Binaries
*
* nixpkgs provides a useful script called makeWrapper which allows a program or
* script to be "wrapped" such that it's run in a particular environment; for
* example, using a PATH which contains its dependencies. Since makeWrapper is a
* Bash function it's a little horrible to use. We can make a nicer interface
* inside Nix (and since I often use makeWrapper in conjunction with
* writeScript, we can combine both):
*
* Example: Passing a script
* -------------------------
* > wrap {
*     name    = "wrapped-script";
*     paths   = with pkgs; [ bash jq ];
*     vars    = {
*       VAR1  = toJSON { someKey = "someValue"; };
*     };
*     script  = ''
*       #!/usr/bin/env bash
*       jq --arg var "$VAR1" '. + $var1.someKey'
*     '';
*   }
* "/nix/store/xhaszq6jg4a9fz3pxax49lnzp78d7wh6-wrapped-script"
*
* Example: Passing a File Directly
* --------------------------------
* > wrap {
*     name  = "wrapped-file";
*     paths = with pkgs; [ python ];
*     vars  = { foo = "bar"; };
*     file  = ./script.py;
*   }
* "/nix/store/vypfn8mrrkd08w6qbwgflvwma82iiwi0-wrapped-file"
*/
{ name ? "wrap"
, paths ? []
, vars ? {}
, file ? null
, script ? null
}:

assert file != null || script != null || abort "wrap needs 'file' or 'script' argument";

let
  escapeShellTwice = (x: escapeShellArg (escapeShellArg x));
  prefixPath       = (p: "--prefix PATH : ${p}/bin");
  setVar           = (n: v: "--set ${escapeShellTwice n} " + "'\"'${escapeShellTwice v}'\"'");

  prefixPathFlags  = (map prefixPath paths);
  setVarFlags      = (mapAttrsToList setVar vars);
  args             = (prefixPathFlags ++ setVarFlags);
  cmdContext       = {
    f           = if file == null then writeScript name script else file;
    buildInputs = [ pkgs.makeWrapper ];
  };
in runCommand name cmdContext ''makeWrapper "$f" "$out" ${builtins.toString args}''
