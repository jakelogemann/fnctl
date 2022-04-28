{ callPackage, mkShell, pkgs, ... }@args: mkShell { 
  packages = with pkgs; [
    cryptsetup ccrypt 
    ddrescue
    dosfstools 
    efibootmgr efivar 
    f2fs-tools
    fuse fuse3 sshfs-fuse
    hdparm sdparm smartmontools 
    jfsutils 
    mdbook
    mkpasswd
    mtools 
    nixUnstable
    nixos-generators 
    nixos-install-tools
    nixos-option 
    ntfsprogs 
    parted gptfdisk gpart
    pciutils 
    ranger
    rsync
    screen 
    socat 
    usbutils
    vim
    xfsprogs.bin 
    zsh 
    # universal-ctags
    binutils
    buildah   # OCI Image builder.
    cacert    # A bundle of X.509 certificates of public Certificate Authorities (CA)
    coreutils # The basic file, shell and text manipulation utilities of the GNU operating system
    curl            # A command line tool for transferring files with URL syntax
    delta    
    dnsutils        # Bind DNS Server
    findutils # GNU Find Utilities, the basic directory searching utilities of the GNU operating system
    fping           # Send ICMP echo probes to network hosts
    gawk      # GNU implementation of the Awk programming language
    gh 
    gitMinimal
    gnugrep   # GNU implementation of the Unix grep command
    gnumake
    gnupatch
    gnupg
    gnused    # GNU sed, a batch stream editor
    gnutar    # GNU implementation of the `tar' archiver
    gzip      # GNU zip compression program
    htop      # better alternative to "top" command.
    hwinfo    # Hardware detection tool
    iputils         # A set of small useful utilities for Linux networking
    jq yq     # JQ (with YAML support by yq).
    kubectl           # Kubernetes CLI
    kubernetes-helm   # Kubernetes deployment tool.
    kustomize         # Customization of kubernetes YAML configurations
    lsd       # prettier alternative to ls
    lshw      # Pretty, indented hardware info
    lsof      # A tool to list open files
    netcat          # Free TLS/SSL implementation
    nettools        # A set of tools for controlling the network subsystem in Linux
    openssl   # A cryptographic library that implements the SSL and TLS protocols
    pass      # Stores, retrieves, generates, and synchronizes passwords securely
    pciutils  # A collection of programs for inspecting and manipulating configuration of PCI devices
    podman    # OCI Container manager designed for k8s.
    pstree    # Shows processes
    rclone          # Command line program to sync files and directories to and from major cloud storage
    readline  # Library for interactive line editing
    ripgrep   # Utility that combines the usability of The Silver Searcher with the speed of grep
    rsync           # A fast incremental file transfer utility
    runc              # daemonless container runtime.
    skaffold  # Healthier alternative to Docker Compose.
    skim
    starship
    terraform
    time      # Tool that runs programs and summarizes the system resources they use
    tmux      # Commonly used Terminal Multiplexor.
    tpm-tools # Trusted process module tools
    tree      # Command to produce a depth indented directory listing
    unzip     # An extraction utility for archives compressed in .zip format
    usbutils  # Tools for working with USB devices, such as lsusb
    vault 
    vector 
    vifm 
    wget            # Tool for retrieving files using HTTP, HTTPS, and FTP
    which     # command to locate the executable file associated with the given command
    whois           # A client for the WHOIS protocol to query the owner of a domain name
    wireguard-tools # Tools for WireGuard secure network tunnel
    wirelesstools   # tools to manipulate wireless extensions
    zoxide 
  ];
}
