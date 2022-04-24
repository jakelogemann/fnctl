# Development

Start your development each time with the following:

```sh
nix develop
```

All the tools you might need should be pre-installed in the development shell
we instantiated above. 

## Flake-y goodness

### Check yourself

Validate the syntax of `flake.nix` and its imports. Useful to catch small typos
and errors.

```sh
nix flake check . 
# warning: flake output attribute 'overlay' is deprecated; use 'overlays.default' instead
# checking flake output 'packages'
```

### Show output

Shows all derived outputs from the current `flake.nix`. This is the list of
things available to users of this project.

```sh
nix flake show .  
# git+file:///etc/nixos?ref=main&rev=e685a14a118cb43e5d53438d2225d7370ed34361
# ├───apps
# │   ├───aarch64-linux
# │   │   ├───docc: app
# │   │   └───nvim: app
# │   ├───i686-linux
# │   │   ├───docc: app
# │   │   └───nvim: app
# │   └───x86_64-linux
# │       ├───docc: app
# │       └───nvim: app
# ├───defaultApp
# │   ├───aarch64-linux: app
# │   ├───i686-linux: app
# │   └───x86_64-linux: app
# ├───devShell
# │   ├───aarch64-linux: development environment 'nix-shell'
# │   ├───i686-linux: development environment 'nix-shell'
# │   └───x86_64-linux: development environment 'nix-shell'
# ├───lib: unknown
# ├───nixosConfigurations
# │   └───laptop: NixOS configuration
# ├───nixosModules
# │   ├───base: NixOS module
# │   └───jlogemann: NixOS module
# ├───overlays
# │   └───default: Nixpkgs overlay
# └───packages
#     ├───aarch64-linux
#     │   ├───devShell: package 'nix-shell'
#     │   ├───docc: package 'docc'
#     │   ├───iso: package 'nixos-dandruff-21.11.20220421.f0d8b06-aarch64-linux.iso'
#     │   ├───osdk: package 'osdk'
#     │   ├───userland: package 'fnctl-userland'
#     │   ├───vim: package 'vim'
#     │   └───vm: package 'nixos-vm'
#     ├───i686-linux
#     │   ├───devShell: package 'nix-shell'
#     │   ├───docc: package 'docc'
#     │   ├───iso: package 'nixos-dandruff-21.11.20220421.f0d8b06-i686-linux.iso'
#     │   ├───osdk: package 'osdk'
#     │   ├───userland: package 'fnctl-userland'
#     │   ├───vim: package 'vim'
#     │   └───vm: package 'nixos-vm'
#     └───x86_64-linux
#         ├───devShell: package 'nix-shell'
#         ├───docc: package 'docc'
#         ├───iso: package 'nixos-dandruff-21.11.20220421.f0d8b06-x86_64-linux.iso'
#         ├───osdk: package 'osdk'
#         ├───userland: package 'fnctl-userland'
#         ├───vim: package 'vim'
#         └───vm: package 'nixos-vm'
#
```

### Metadata

Shows all metadata for this `flake.nix`. This is useful for examining inputs/changes/etc.

```sh
nix flake metadata . 
# Resolved URL:  git+file:///etc/nixos
# Locked URL:    git+file:///etc/nixos
# Description:   jlogemann's dandruff (eww)
# Path:          /nix/store/llmdrs4p765ggf63kxyinnjrg5h8as8d-source
# Last modified: 2022-04-22 14:33:00
# Inputs:
# ├───home-manager follows input 'stable'
# ├───nixos-generators: github:nix-community/nixos-generators/b0326ae4f0761b9b482b8472975b3a8e86940ce2
# │   ├───nixlib: github:nix-community/nixpkgs.lib/28a5b0557f14124608db68d3ee1f77e9329e9dd5
# │   └───nixpkgs follows input 'stable'
# ├───nixos-hardware: github:nixos/nixos-hardware/6b4ebea9093c997c5f275c820e679108de4871ab
# ├───stable: github:NixOS/nixpkgs/f0d8b069143f12ca41174bc80a5bc03cca7be438
# └───unstable: github:NixOS/nixpkgs/1ffba9f2f683063c2b14c9f4d12c55ad5f4ed887
```

### Updating dependencies

Update the dependencies ("inputs") of `flake.nix` and store new versions in
`flake.lock`. 

```sh
nix flake update .  
```

## Building packages

### individual packages 

TODO: write this section, but essentially: `nix build ...`

### in NixOS

```sh
nixos-rebuild build         # output as ./result symlink.
nixos-rebuild build-vm      # also output as ./result symlink.
nixos-rebuild dry-build     # use often
nixos-rebuild dry-activate  # use often
nixos-rebuild switch        # use only when you're "sure" its "safe".
```

#### `nixos-rebuild` commands

- `build`: Build the current configuration and but do not switch to it.
  Produces a symlink of the built configuration at `./result/`.

- `dry-activate`: Build the current configuration and and "pretend" to switch
  to it... Attempts to predict changes made to the OS.

- `switch`: Build the current configuration and switch to it immediately. This
  is the "least safe" of the `nixos-rebuild` commands.

- `boot`: Build the current configuration and switch to it on next boot. This
  is the "safe" but can bork the next boot of the machine.. so use it
  carefully. 

- `test`: Build the current configuration and switch to it on immediately
  (revert on next boot). This is a much more "safe" way to update. If the
  machine is borked after a risky change, simply reboot the host to revert the
  change.

- `build-vm`: Build the current configuration as a QEMU Virtual Machine image.
  Produces a symlink of the built image at `./result/`.  Note there is also
  `build-vm-with-bootloader` which if you need it; you know what it does
  by the name.. otherwise don't worry about it.

## REPL

Useful for inspecting the current configuration and the options available to us.
Open the REPL (or "Shell") with the following command:

```sh
nix repl .
# Welcome to Nix 2.7. Type :? for help.
#
# "Added 9 variables."
#
# From the nix repl, we now have our current host, so we can inspect with
# completion by typing "self." and pressing <TAB> a couple times we'll see the following: 
# self._module    self.config     self.extraArgs  self.options    self.pkgs       self.type

self.config.services.xserver.enable
# true

self.pkgs.coreutils.version
# "9.0"

self.pkgs.unstable.coreutils.version
# "9.0"

# Exit by typing "exit" or Ctrl-D.
```
^ _Example nix repl usage._

### Building the VM

```nix
# from the nix repl.
:b self.pkgs.fnctl.recovery.vm
# This derivation produced the following outputs:
#   out -> /nix/store/ah7y3rdb9gwbjw0danizbwh1523x0x1s-nixos-vm
#   [57 built, 17 copied (38.1 MiB), 5.4 MiB DL]
# 
```

Exit by typing "exit" or Ctrl-D. Then run the `./bin/run-nixos-vm` command.. something like:

```sh
/nix/store/ah7y3rdb9gwbjw0danizbwh1523x0x1s-nixos-vm/bin/run-nixos-vm
```

Easy as that!