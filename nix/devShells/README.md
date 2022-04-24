# devShells

Essentially these are "development environments" pinned with their dependencies.

## Running the default DevShell

```sh
# nix develop '[<path-to-flake>]' [-c <COMMAND>]
#
# Example(s):

nix develop '.'

nix develop '.' -c nvim
``````

## Running other DevShells

```sh
# nix develop '<path-to-flake>#<name>' [-c <COMMAND>]
#
# Example:
nix develop '.#networking' 

nix develop '.#networking' -c mtr
```
