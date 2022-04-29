{ config, lib, pkgs, ... }: with lib; {

  imports = [ 
  ];

  options.fnctl = {
    enable = mkEnableOption "fnctl's custom module(s)";
  };

  config = let cfg = config.fnctl; in mkIf cfg.enable {
    system.nixos.tags = [ "fnctl" ];
  };
} 
