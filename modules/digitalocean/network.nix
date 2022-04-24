{ config, lib, pkgs, ... }: with lib; {

  options.digitalocean.network = {
    addHosts = mkEnableOption "modify /etc/hosts with well-known hosts";
  };

  config = let cfg = config.digitalocean; in mkIf (cfg.enable) {
    /* networking.hosts = mkIf (cfg.enable && cfg.network.addHosts) {
    }; */
  };
} 
