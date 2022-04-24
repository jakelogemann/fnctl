# Packages

## Building Packages
```sh
# nix build '<.|path-to-flake>#<pkg-name>'
#
# Example(s):
nix build '.#neovim' && ./result/bin/nvim --version
```

## Running Packages
```sh
# nix run '<.|path-to-flake>#<pkg-name>'
#
# Example(s):
nix run '.#neovim' -- --version
```
