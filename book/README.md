# FnCtl OS

<center><img width="256" height"256" src="./assets/logo.png" alt="logo" /></center>

**TL;DR**: a decent "prefab" developer environment that is:

- Based on NixOS.

- Free & open-source (_very soon!_)

- Easily self-hosted/self-service on several clouds; virtual machines; and
  various hardware (to some degree).

## An _"Operating System"_?

Well, okay, no- Not entirely. It's based on a fairly opinionated NixOS
configuration thats more like a framework then an operating system.
`FnCtl/NixOS-Config` would have been a perfectly good name, but.. also.. no.
:shrug: we'll write a longer defense of why this name is clearer at some point
in the future, but for now.. Yup. Its an opinionated "operating system" focused
on being "functional" for a developer without **too much** regular maintenance.

It aims to _"bend the branches down"_ on a "power-user" experience with decent
documentation to provide an open-source, engaging, interactive learning
environment that respects your/our/everyone's privacy (to the best of our
**very** human ability).

## Goals

- Be near instantly "functional" for a generic _"full-stack"/"devops"/"cloud" "engineer"_.

- Provide sane configurations for an ergonomic "power-user" experience.

- Provide documentation (and references to documentation) for as many contained
  tools as possible.

- Document _**last-known**_ best practices and update with any feedback from
  _readers like **you**_.

- Reduce maintenance (and frustration) for newer/casual users to
  provision/update a development workspace with minimal effort.

  - Automate updating of dependencies; validation of syntax/semantics using GitHub:Actions.

- Provide as many output formats as possible (_Parallels; VirtualBox; ISO;
  QCOW2; DigitalOcean Image; etc._), with corresponding guides for each use-case.
