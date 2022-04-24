{ readDir, hasSuffix, filterAttrs, mapAttrs }:
# Enumerate files with extension ".nix" for evaluation. This is useful for
# automagically importing files from directories or for debugging via the
# REPL.

# Examples:
#  > a = dirNixFiles ./modules
#  > a
#  {
#    "bar.nix"     = /nix/store/...modules/bar.nix;
#    "foo.nix"     = /nix/store/...modules/foo.nix;
#    "default.nix" = /nix/store/...modules/default.nix;
#  }
#  > (import a."bar.nix" { inherit pkgs lib; })
#

# Supply a directory which contains nix files.
targetDir:

let
  dirContents   = with builtins; readDir (toPath targetDir);
  selectNixFiles = filterAttrs (name: value: (hasSuffix ".nix" name));
  attrIsNixFile = (name: _: hasSuffix ".nix" name);
  selection     = selectNixFiles dirContents;
  fileInStore   = (name: _: "${targetDir}/${name}");

in mapAttrs fileInStore selection


