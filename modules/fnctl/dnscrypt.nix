{ config, lib, pkgs, home-manager, unstable, ... }: with lib; {
  options.fnctl.dns = {
    enable = mkOption {
      default = true;
      description = "enable the encyrypted dns configuration";
      type = types.bool;
    };
  };

  config = let cfg = config.fnctl.dns; in mkIf cfg.enable {
    networking.nameservers = [ "127.0.0.1" "::1" ];
    networking.resolvconf.enable = false;
    networking.dhcpcd.extraConfig = "nohook resolv.conf" /* optional */;
    networking.networkmanager.dns = "none" /* optional */;
    services.dnscrypt-proxy2.enable = true;
    services.dnscrypt-proxy2.settings = {
      ipv6_servers = true;
      ipv4_servers = true;
      require_nolog = true;
      require_nofilter = true;
      dns_client_subnet = ["0.0.0.0/0" "2001:db8::/32"];
      require_dnssec = true;
      blocked_query_response = "refused";
      sources.public-resolvers.urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
      sources.public-resolvers.cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
      sources.public-resolvers.minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      # server_names = [ ... ];
    };

    systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = mkForce "dnscrypt-proxy2";
  };
} 
