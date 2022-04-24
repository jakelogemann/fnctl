<!-- markdownlint-disable MD041 MD013 -->
<center><img id="logo" width="256" height"256" src="https://fnctl.github.io/lib/favicon.png" alt="FnCtl" /></center>

Library of Nix functions.

## See Also

Here is a *bunch* of random, mostly useful links that we've found useful and
attempted to organize for easy access:

- [**nixos.org**](https://nixos.org/learn.html)
- [nix](https://nixos.org/manual/nix/stable/): *the package manager and language*
  - [`builtins.*`](https://nixos.org/manual/nix/stable/expressions/builtins.html): *core functions for nix lang*
- [nixpkgs](https://nixos.org/manual/nixpkgs/stable): *stdlib for nix and its packages*
  - [`nixpkgs.lib.*`](https://nixos.org/manual/nixpkgs/stable/#sec-functions-library): *the **literal** stdlib*
  - [search nixpkgs](https://search.nixos.org/packages?query=) 
- [NixOS](https://nixos.org/manual/nixos/stable): *linux built on nix/nixpkgs/systemd*
  - Example: [Hardened NixOS Profile](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix)
  - [search nixos options](https://search.nixos.org/options?query=)
- **guides**
  - [cross-compilation](https://nixos.org/guides/cross-compilation.html)
  - language-specific
    - [golang](https://nixos.org/manual/nixpkgs/stable/#sec-language-go)

### Additional Resources (Unofficial)

- [🕶 awesome nix](https://github.com/nix-community/awesome-nix): a community
  maintained list of awesome projects in the Nix/NixOS community.
- [NixOS.wiki](https://nixos.wiki/wiki/Main_Page): a community maintained wiki
  that functions as the "stack overflow" of NixOS.
- [christine.website/blog](https://christine.website/blog): Incredibly
  insightful and detailed blog on various topics (including Nix flakes) that we
  found very useful when learning.
- [hitchhiker's guide to nixos](https://talks.cont.run/the-hitchhiker-s-guide-to-nixos/)
- [nixcloud](https://github.com/nixcloud)
- [nix-filter](https://github.com/numtide/nix-filter)
- [nix.dev](https://nix.dev)

#### Discovering New Things

- [search (official) flakes registry](https://search.nixos.org/flakes?query=) (*portable user-defined configurations*)
- [github repos with a flake.nix (updated since 2021)](https://github.com/search?q=filename%3Aflake.nix+pushed%3A%3E2021&type=Repositories)

#### NixOS Configurations

- [github:mitchellh/nixos-config](https://github.com/mitchellh/nixos-config)
