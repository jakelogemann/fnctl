{ mkOption, types }: # Creates an "opt-out"  Option.
description: mkOption {
  type = types.bool;
  default = true;
  inherit description;
}

