 { config, lib, pkgs, ... }: with lib; {
  options.users.jlogemann =  {
     enable = mkEnableOption "enable my user!";
     operator = mkEnableOption "enable operation privs for me!";
     primaryUser = mkEnableOption "enable my custom OS-level settings, only when I'm the \"primary user\" of a machine. this option implies .enable";
   };

  config = let 
    cfg = config.users.jlogemann; 
    enabled = cfg.enable || cfg.primaryUser;
  in mkIf enabled {
    users.groups.jlogemann = { };
    users.users.jlogemann = mkDefault {
      home           = "/home/jlogemann";
      uid            = 1000;
      description    = "Jake Logemann";
      group          = "jlogemann";
      isNormalUser   = true;
      createHome     = true;
      shell          = pkgs.zsh;
      extraGroups    = concatLists [ 
        ["users"]
        (optionals config.services.xserver.enable ["video"])
        (optionals config.virtualisation.docker.enable ["docker"])
      ]; 
      packages       = with pkgs; (concatLists [
        [ 
          cacert    # A bundle of X.509 certificates of public Certificate Authorities (CA)
          coreutils # The basic file, shell and text manipulation utilities of the GNU operating system
          curl      # A command line tool for transferring files with URL syntax
          dnsutils  # Bind DNS Server
          findutils # GNU Find Utilities, the basic directory searching utilities of the GNU operating system
          gawk      # GNU implementation of the Awk programming language
          gnugrep   # GNU implementation of the Unix grep command
          gnused    # GNU sed, a batch stream editor
          gnutar    # GNU implementation of the `tar' archiver
          gzip      # GNU zip compression program
          lsd       # prettier alternative to ls
          lsof      # A tool to list open files
          netcat    # Free TLS/SSL implementation
          gnumake
          gnupatch
          openssl   # A cryptographic library that implements the SSL and TLS protocols
          pass      # Stores, retrieves, generates, and synchronizes passwords securely
          gnupg
          neofetch 
          gh gitMinimal delta    
          jq yq     # JQ (with YAML support by yq).
          pstree    # Shows processes
          rclone          # Command line program to sync files and directories to and from major cloud storage
          readline  # Library for interactive line editing
          ripgrep   # Utility that combines the usability of The Silver Searcher with the speed of grep
          rsync           # A fast incremental file transfer utility
          skim
          starship
          time      # Tool that runs programs and summarizes the system resources they use
          tmux      # Commonly used Terminal Multiplexor.
          tree      # Command to produce a depth indented directory listing
          htop      # better alternative to "top" command.
          unzip     # An extraction utility for archives compressed in .zip format
          wget            # Tool for retrieving files using HTTP, HTTPS, and FTP
          which     # command to locate the executable file associated with the given command
          whois           # A client for the WHOIS protocol to query the owner of a domain name
          wireguard-tools # Tools for WireGuard secure network tunnel
          iputils   # A set of small useful utilities for Linux networking
          zoxide vifm vector vault terraform
          binutils
        ] 
        (optionals config.services.xserver.enable [ 
          gimp 
          firefox 
          google-chrome 
          alacritty 
          networkmanagerapplet 
          # slack 
          vscodium
        ])
        (optionals (cfg.operator || cfg.primaryUser) [ 
          nixos-option 
          nixos-install-tools 
          nixFlakes
          buildah   # OCI Image builder.
          fping     # Send ICMP echo probes to network hosts
          hwinfo    # Hardware detection tool
          lshw      # Pretty, indented hardware info
          nettools        # A set of tools for controlling the network subsystem in Linux
          pciutils  # A collection of programs for inspecting and manipulating configuration of PCI devices
          podman    # OCI Container manager designed for k8s.
          runc              # daemonless container runtime.
          skaffold  # Healthier alternative to Docker Compose.
          tpm-tools # Trusted process module tools
          usbutils  # Tools for working with USB devices, such as lsusb
          wirelesstools   # tools to manipulate wireless extensions
        ])
        (optionals (hasAttr "fnctl" pkgs) (with pkgs.fnctl; [ 
          vim
        ]))
        (optionals (hasAttr "never-exists" pkgs) (with pkgs.never-exists; [ 
          /* sanity check. */
          never-installed
        ]))
      ]);
    };

    documentation = mkIf cfg.primaryUser {
      dev.enable = true;
      enable = true;
      info.enable = true;
      man.enable = true;
      man.generateCaches = true;
      nixos.enable = true;
    };

    i18n = mkIf cfg.primaryUser {
      defaultLocale = mkDefault "en_US.UTF-8";
    };

    nix = mkIf (cfg.operator || cfg.primaryUser) {
      /* if I am an operator I should have access to the nix cli. */
      allowedUsers = mkAfter (optionals cfg.operator [ "jlogemann" ]);
    };

    nixpkgs = mkIf cfg.primaryUser {
      config.allowUnfree = true; 
    };

    time = mkIf cfg.primaryUser {
      timeZone = mkDefault "America/New_York";
    };

    services = mkIf cfg.primaryUser {
      avahi.enable = mkForce false /* avahi (aka "Bonjour") service discovery. */;
      fwupd.enable = mkDefault true /* firmware updater daemon. */;
      gnome.tracker-miners.enable = mkForce false /* lets... NOT index everything... */;
      gnome.tracker.enable = mkForce false /* prefer `rg` over Gnome's Catfish thing. */;
      haveged.enable = mkForce true /* Automatically refills /dev/random with entropy. */;
      openssh.enable = mkDefault false /* SSH Server. */;
      pcscd.enable = mkDefault true /* smartcard daemon (yubikeys/u2f). */;
      printing.enable = mkForce false /* CUPS (Printer daemon) */;
    };
  };
} 
