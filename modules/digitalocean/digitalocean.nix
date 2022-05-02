{ config, lib, pkgs, ... }: with lib; {

  imports = [ 
    ./network.nix 
  ];

  options.digitalocean = {
    enable = mkEnableOption "stub for hypothetical future internal digitalocean module(s).";
  };

  config = let cfg = config.digitalocean; in mkIf cfg.enable {
    system.nixos.tags = [ "digitalocean" ];
  };
} 
