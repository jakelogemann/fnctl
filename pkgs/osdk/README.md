# Operating System Development Kit (_"OSDK"_)

## Purpose

- pre-install commonly required tools for
  - "developing" the NixOS host's configuration.
  - "burning" a disk image to a USB/CD/DVD/Floppy (lol).
  - version control (`git`, and similar tasks)

## Development

- **Build from Project Root**: `nix build ".#osdk"`
- **Package List**: [`./pkgs.nix`](./pkgs.nix)
- **Nix Shell**: [`./shell.nix`](./shell.nix)
  - run from project root: `nix develop` (as root or w/ `sudo`)
