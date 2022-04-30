{ config, lib, pkgs, home-manager, unstable, ... }: with lib; {
  options.fnctl.tuneSysCtl = mkOption {
    default = true;
    description = "enable the sysctl tweaks configuration";
    type = types.bool;
  };

  config = let 
    cfg = config.base; 
    enabled = cfg.enable; 
  in mkIf config.fnctl.tuneSysCtl {
    boot.kernel.sysctl = {
      /* increase max socket connections to 100k (default 128). */
      "net.core.somaxconn"            = mkDefault 100000;

      /* Increase network receive queues (Default: 1000) */
      "net.core.netdev_max_backlog"   = mkDefault 5000; /* Default: 1000 */
      "net.core.netdev_budget"        = mkDefault 1500; /* Default:  300 */
      "net.core.netdev_budget_usecs"  = mkDefault 4000; /* Default: 2000 */

      /* TCP Fast Open is an extension to the transmission control protocol
      * (TCP) that helps reduce network latency by enabling data to be
      * exchanged during the sender’s initial TCP SYN [2]. Using the value 3
      * instead of the default 1 allows TCP Fast Open for both incoming and
      * outgoing connections (default: 1). */
      "net.ipv4.tcp_fastopen"  = mkDefault 3;

      /* Tweak the pending connection handling
      * tcp_max_syn_backlog is the maximum queue length of pending connections
      * 'Waiting Acknowledgment'. In the event of a synflood DOS attack, this
      * queue can fill up pretty quickly, at which point tcp_syncookies will
      * kick in allowing your system to continue to respond to legitimate
      * traffic, and allowing you to gain access to block malicious IPs. If the
      * server suffers from overloads at peak times, you may want to increase
      * this value a little bit: (default: 512) */
      "net.ipv4.tcp_max_syn_backlog" = mkDefault 8192; 
      "net.ipv4.tcp_syncookies"      = mkDefault 1;

      /* tcp_max_tw_buckets is the maximum number of sockets in 'TIME_WAIT'
      * state. After reaching this number the system will start destroying the
      * socket that are in this state. Increase this to prevent simple DOS
      * attacks: */
      "net.ipv4.tcp_max_tw_buckets" = mkDefault 2000000;

      /* tcp_tw_reuse sets whether TCP should reuse an existing connection in
      ** the TIME-WAIT state for a new outgoing connection if the new timestamp
      ** is strictly bigger than the most recent timestamp recorded for the
      ** previous connection. */
      "net.ipv4.tcp_tw_reuse" = mkDefault 1;

      /* tcp_slow_start_after_idle sets whether TCP should start at the default
      ** window size only for new connections or also for existing connections
      ** that have been idle for too long. This setting kills persistent single
      ** connection performance and could be turned off: */
      "net.ipv4.tcp_slow_start_after_idle" = mkDefault 0;

      /* Specify how many seconds to wait for a final FIN packet before the socket is
      * forcibly closed. This is strictly a violation of the TCP specification, but
      * required to prevent denial-of-service attacks. In Linux 2.2, the default
      * value was 180 */
      "net.ipv4.tcp_fin_timeout" = mkDefault 10;

      /* Adjust TCP Keep Alive */
      "net.ipv4.tcp_keepalive_time"   = mkDefault 60;
      "net.ipv4.tcp_keepalive_intvl"  = mkDefault 10;
      "net.ipv4.tcp_keepalive_probes" = mkDefault 6;

      /* The longer the MTU the better for performance, but the worse for
      * reliability. This is because a lost packet means more data to be
      * retransmitted and because many routers on the Internet can't deliver
      * very long packets: */
      "net.ipv4.tcp_mtu_probing" = mkDefault 1; 

      /* Protect against tcp time-wait assassination hazards, drop RST packets
      * for sockets in the time-wait state. Not widely supported outside of
      * Linux, but conforms to RFC:
      "net.ipv4.tcp_rfc1337" = 1; /

      /* Only accept packets we know the reverse path of is correct. */
      "net.ipv4.conf.default.rp_filter" = mkDefault null;
      "net.ipv4.conf.all.rp_filter"     = mkDefault null;

      /* Allow saves to occur even if memory is full. */
      "vm.overcommit_memory" = mkDefault 1;

      /* Increase the number of inotify watches. Helps when monitoring a large
      * directory with cloud sync services. The setting will depend on how much RAM
      * is on the system. While 524288 is the maximum number of files that can be
      * watched, in an environment that is particularly memory constrained, a lower
      * number may be preferred. Each file watch takes up 540 bytes (32-bit) or
      * ~1kB (64-bit), so assuming that all 524288 watches are consumed that
      * results in an upper bound of around 256MB (32-bit) or 512MB (64-bit).
      *
      * NOTE: Conflicts, if using mkDefault, with:
      * `/nix/var/nix/profiles/per-user/root/channels/nixos/nixos/modules/services/x11/xserver.nix'
      */
      "fs.inotify.max_user_watches"   = 1048576;
      "fs.inotify.max_user_instances" = 1024;
      "fs.inotify.max_queued_events"  = 32768;
    };
  };
} 
