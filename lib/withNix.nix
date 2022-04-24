{ pkgs, getEnv, mkMerge }:
# We might want to use Nix commands from within a builder, for example to
# evaluate a dynamically-generated expression, to add a file to the store or to
# invoke some other build. This tends to fail due to missing environment
# variables. The following will augment a given attribute set to contain the
# needed config:

attrs:


mkMerge 
[
  attrs
  { buildInputs = (attrs.buildInputs or []) ++ [ pkgs.nix ];
    NIX_PATH    =
      if getEnv "NIX_PATH" == ""
      then "nixpkgs=${builtins.toString <nixpkgs>}"
      else getEnv "NIX_PATH";
    NIX_REMOTE  =
      if getEnv "NIX_REMOTE" == ""
      then "daemon"
      else getEnv "NIX_REMOTE"; }
]

