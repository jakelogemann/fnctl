# Notes

> Random commands I've been using _that I should document or something_ but don't
> want to lose until I do...

- **Build the ISO**: `nixos-rebuild --install-bootloader --flake .#iso build`
- **REPL for the ISO**: `nix repl ./default-nix --argstr name iso`
- **Build the VM**: `nixos-rebuild --install-bootloader --flake .#vm-aarch64 build`
- **REPL for the VM**: `nix repl ./default-nix --argstr name vm-aarch64`