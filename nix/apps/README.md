# Apps

Essentially these are reusable scripts pinned with their dependencies.

## Running the default App
```sh
# nix run '<.|path-to-flake>' [--] [options]
# For example:
nix run '.' 
```

## Running Other Apps
```sh
# nix run '<.|path-to-flake>#<app-name>'
#
# Example(s):
nix run '.#zola' -- --version
```

## Building Apps

They're rebuilt automatically at runtime on each usage.
