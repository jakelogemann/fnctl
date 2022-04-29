/* currently can be built/used with:
**   nixos-rebuild --install-bootloader -I nixos-config=$PWD/configs/vm-aarch64.nix <build|switch|dry-activate|etc...>
*/ { config, pkgs, lib, ... }: with lib; {
  disabledModules = ["virtualisation/parallels-guest.nix"];
  imports = [ 
    ../modules/parallels-guest.nix 
    ../modules/fnctl/default.nix
  ];

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ahci" "nvme" "xhci_pci" "usbhid" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/disk/by-label/boot"; fsType = "vfat"; };
  swapDevices = [ ];
  networking.interfaces.enp0s5.useDHCP = mkForce true;
  console.earlySetup = true;
  console.useXkbConfig = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  hardware.pulseaudio.enable = true; 
  hardware.video.hidpi.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostName = "fnctl-os";
  nix.extraOptions = "experimental-features = nix-command flakes";
  nix.package = pkgs.nixUnstable;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.mtr.enable = true;
  services.openssh.enable = false;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "yes";
  services.printing.enable = false;
  services.xserver.libinput.enable = true;
  sound.enable = true;
  system.stateVersion = "22.05"; 
  time.timeZone = "America/New_York";
  users.users.root.initialPassword = "";
  users.users.root.shell = pkgs.zsh;
  hardware.parallels.enable = true;
  hardware.parallels.autoMountShares = true;
  hardware.parallels.package = (config.boot.kernelPackages.callPackage ../pkgs/prl-tools.nix {});
  virtualisation.docker.enable = true;
  users.motd = "Welcome to FnCtl OS";

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
  environment.variables.EDITOR = "vim";

  environment.systemPackages = with pkgs; [
    (vim_configurable.customize {
      name = "vim";
      vimrcConfig.packages.myVim.start = with pkgs.vimPlugins; [ 
        fugitive
        i3config-vim
        jq-vim
        onedark-vim
        polyglot
        vim-automkdir
        vim-vinegar
        vim-crates
        vim-go
        vim-hcl
        vim-nix
        vim-scriptease
        vim-sensible
        vim-signify
        vim-startify
        vim-surround
        vim-toml
        vim-which-key
      ];
      vimrcConfig.customRC = ''
        colorscheme onedark

        " Put leader key under the thumb
        nnoremap <Space> <NOP>
        let mapleader = "\<Space>"

        " General configuration
        set path+=** " recursively add contents of current directory to path
        set list " show invisible characters such as tabs and trailing spaces
        set number relativenumber " show relative line numbers except for current line
        set ignorecase smartcase " ignore case unless search patterns contains capitals
        set showcmd " show commands as they're being typed
        set hidden " allow switching buffers without saving
        set hlsearch " search highlighting on
        set nobackup noswap

        " Easier access to frequent commands
        nnoremap <leader><leader> :Buffers<Return>
        nnoremap <leader>bd :bd<CR>
        nnoremap <leader>g :Git<CR>
        nnoremap <leader>q :q<CR>
        nnoremap <leader>s :w<CR>
        nnoremap <leader>w :w<CR>
        nnoremap <leader>x :x<CR>
        nnoremap <leader>f :Files<Return>
        nnoremap <leader>r :Rename <c-r>=expand('%')<CR>

        " Line wrapping
        set mouse=a "enable all mouse support.
        set wrap " enable soft-wrapping
        set linebreak " don't soft-wrap mid-word
        set breakindent " continue indentation of soft-wrapped line
        set showbreak=\\\  " prefix soft-wrapped lines with a backslash
        set textwidth=80 " column to hard-wrap at (with gq for example)
        set formatoptions-=tc " don't automatically hard-wrap text or comments

        " Use tabs for indentation and spaces for alignment.
        " This ensures everything will line up independent of tab size.
        " - https://suckless.org/coding_style
        " - https://vim.fandom.com/wiki/VimTip1626
        set noexpandtab copyindent preserveindent softtabstop=0 shiftwidth=2 tabstop=2

        " Spellchecking
        " Vim offers suggestions! See `:help z=` and `:help i^xs`...
        set nospell " off by default
        set spelllang=en_us
        nnoremap <leader>rs 1z=
      '';
    })


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
