{ config, lib, pkgs, ... }: with lib; {

  imports = [ 
  ];

  options.fnctl = {
    enable = mkEnableOption "fnctl's custom module(s)";
  };

  config = let cfg = config.fnctl; in mkIf cfg.enable {
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.enableContainers = true /* NixOS declarative containers. */;
    boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
    boot.supportedFilesystems = [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
    console.earlySetup = true;
    console.font = "Lat2-Terminus16";
    console.useXkbConfig = true;
    documentation.dev.enable = true;
    documentation.enable = true;
    documentation.info.enable = true;
    documentation.man.enable = true;
    documentation.man.generateCaches = true;
    documentation.nixos.enable = true;
    environment.variables.EDITOR = "vim";
    i18n.defaultLocale = "en_US.UTF-8";
    networking.firewall. enable = true;
    networking.firewall.allowedTCPPorts = [];
    networking.firewall.allowedUDPPorts = [];
    networking.hostName = mkDefault "fnctl-os";
    nix.extraOptions = ''experimental-features = nix-command flakes'';
    nix.gc.automatic = true;
    nix.gc.dates = "daily";
    nix.gc.options = ''--max-freed "$((30 * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | ${pkgs.gawk}/bin/awk '{ print $4 }')))"'';
    nix.package = pkgs.nixFlakes;
    nixpkgs.config.allowUnfree = true; 
    nixpkgs.config.allowUnsupportedSystem = true;
    powerManagement.cpuFreqGovernor = mkDefault "powersave";
    programs.gnupg.agent.enable = mkDefault true;
    programs.gnupg.agent.enableSSHSupport = mkDefault  true;
    programs.mtr.enable = mkDefault true;
    security.allowUserNamespaces = true;
    security.forcePageTableIsolation = true;
    security.rtkit.enable = true;
    security.virtualisation.flushL1DataCache = "always";
    services.avahi.enable = mkDefault false;
    services.fwupd.enable = true;
    services.gnome.tracker-miners.enable = mkForce false;
    services.gnome.tracker.enable = mkForce false;
    services.haveged.enable = true /* Automatically refills /dev/random with entropy. */;
    services.openssh.enable = mkDefault false;
    services.openssh.passwordAuthentication = mkForce false;
    services.pcscd.enable   = true /* Allows smartcards (yubikeys). */;
    services.printing.enable = mkForce false;
    sound.enable = mkDefault true;
    system.nixos.tags = [ "fnctl" ];
    time.hardwareClockInLocalTime = mkDefault true;
    time.timeZone = mkDefault "America/New_York";
    users.defaultUserShell = pkgs.zsh;
    users.motd = "Welcome to FnCtl OS";
    users.users.root.initialPassword = "";
    users.users.root.shell = pkgs.zsh;
    virtualisation.docker.enable   = mkDefault true;
    virtualisation.libvirtd.enable = mkDefault false;
  };
} 
