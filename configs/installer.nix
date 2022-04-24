{ config, pkgs, modulesPath, lib, ... }: with lib; {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
  ];

  config = {
    base.enable = true;
    base.gui.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
