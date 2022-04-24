{ isDerivation, isString, hasPrefix, concatMap, getAttr, attrNames
, escapeShellArg, runCommand, concatStringsSep, pkgWithContext
, ... }:

let
  inherit (builtins) typeOf;

  # we might have a bunch of derivations or paths neatly arranged in Nix attribute
  # sets which we'd like to write to disk, without wanting to write a bunch of
  # boilerplate. We can do this as follows:
  isPath  = x: typeOf x == "path" || (isString x && hasPrefix "/" x);

  toPaths = prefix: val:
    if isPath val || isDerivation val then [{ name  = prefix; value = val; }]
    else concatMap
    (n: toPaths (if prefix == "" then n else prefix + "/" + n) (getAttr n val))
    (attrNames val);

  toCmds = attrs:
  (map (entry:
  let
    n = escapeShellArg entry.name;
    v = escapeShellArg entry.value;
  in ''
    mkdir -p "$(dirname "$out"/${n})"
    ln -s ${v} "$out"/${n}
  '') (toPaths "" attrs));

in

attrs:

runCommand "merged" {} (
  ''mkdir -p "$out"'' + concatStringsSep "\n" (toCmds attrs)
)
