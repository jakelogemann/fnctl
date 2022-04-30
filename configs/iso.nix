{ config, pkgs, modulesPath, lib, ... }: with lib; {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
  ];

  config = {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    fnctl.enable = true;
    users.jlogemann.enable = true;
    users.jlogemann.gui.enable = true;
  };
}
