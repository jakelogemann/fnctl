/* currently can be built/used with:
**   nixos-rebuild --install-bootloader -I nixos-config=$PWD/configs/vm-aarch64.nix <build|switch|dry-activate|etc...>
*/ { config, pkgs, lib, ... }: with lib; {
  disabledModules = ["virtualisation/parallels-guest.nix"];
  imports = [ 
    ../modules/parallels-guest.nix 
    ../modules/fnctl/fnctl.nix
    ../modules/users/jlogemann/jlogemann.nix
  ];

  fnctl.enable = true;
  fnctl.dns.enable = true;
  users.jlogemann.enable = true;

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ahci" "nvme" "xhci_pci" "usbhid" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/disk/by-label/boot"; fsType = "vfat"; };
  swapDevices = [ ];
  networking.interfaces.enp0s5.useDHCP = mkForce true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  hardware.pulseaudio.enable = true; 
  hardware.video.hidpi.enable = true;
  services.xserver.libinput.enable = true;
  system.stateVersion = "22.05"; 
  hardware.parallels.enable = true;
  hardware.parallels.autoMountShares = true;
  hardware.parallels.package = (config.boot.kernelPackages.callPackage ../pkgs/prl-tools.nix {});
  services.xserver = {
    enable = true;
    desktopManager.wallpaper.mode = "scale";
    desktopManager.xterm.enable = false;
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "root";
    displayManager.defaultSession = "none+i3";
    displayManager.lightdm.enable = true;
    windowManager.i3.enable = true;
    windowManager.i3.package = pkgs.i3-gaps;
    windowManager.i3.extraPackages = with pkgs; [ dmenu rofi arandr dex unclutter dunst alacritty nerdfonts i3blocks ];
  };

  environment.systemPackages = with pkgs; [
    fnctl.vim

    alacritty kitty
    binutils
    chromium
    coreutils
    curl wget
    dnsutils
    doctl
    findutils
    findutils
    firefox
    fping
    fzf
    gawk gnugrep gnumake gnupatch gnupg gnused gnutar
    gh go-jira
    google-chrome
    gzip
    htop
    hwinfo
    jq
    lsd
    lshw
    lsof
    neofetch
    netcat
    nettools
    nixos-option
    pass
    pciutils
    ranger
    rclone
    readline
    runc
    skim
    starship
    terraform
    time
    tmux
    tree
    unzip
    usbutils
    vault
    vector
    vifm
    vscodium
    neovim
    which
    whois
    wireguard-tools
    yq
    zoxide
    (writeShellScriptBin "fix-display" "${xorg.xrandr}/bin/xrandr --output Virtual-1 --auto")
  ];
}/*
vim: et sts=2 ts=2
*/
