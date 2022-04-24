{ pkgs, callPackage, ... }@args: 
let
  userland = callPackage ../userland/pkgs.nix {};

in with pkgs; lib.concatLists [ 
  userland [ 
    vim
    cryptsetup ccrypt 
    ddrescue
    dosfstools 
    efibootmgr efivar 
    f2fs-tools
    fuse fuse3 sshfs-fuse
    hdparm sdparm smartmontools 
    jfsutils 
    mkpasswd
    mtools 
    mdbook
    nixos-install-tools
    nixos-option 
    ntfsprogs 
    parted gptfdisk gpart
    pciutils 
    ranger
    rsync
    screen 
    socat 
    unstable.nixFlakes
    unstable.nixos-generators 
    usbutils
    xfsprogs.bin 
    zsh 
  ]]
