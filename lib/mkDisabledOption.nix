{ mkOption, types }:
# Creates a disabled NixOS Option.

description: 

mkOption {
  type = types.bool;
  default = false;
  inherit description;
}

