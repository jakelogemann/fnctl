{
  config,
  pkgs,
  lib,
  hostName,
  system,
  ...
}:
with lib; let
  mkCSV = concatStringsSep ",";
  configDir = "/media/psf/fnctl/pvm";
  userName = "developer";
  groupName = "fnctl";
  defaultFont = "TerminusTTF Nerd Font Mono";

  ac = "#1E88E5";
  mf = "#383838";

  bg = "#111111";
  fg = "#FFFFFF";

  # Colored
  primary = "#91ddff";

  # Dark
  secondary = "#141228";

  # Colored (light)
  tertiary = "#65b2ff";

  # white
  quaternary = "#ecf0f1";

  # middle gray
  quinternary = "#20203d";

  # Red
  urgency = "#e74c3c";
in {
  fonts.fonts = with pkgs; [
    terminus-nerdfont
    xkcd-font
    hack-font
  ];

  virtualisation.docker.rootless.package = pkgs.docker-edge;
  environment.systemPackages = with pkgs; [
    aide
    alacritty
    alejandra
    docker-credential-helpers
    firefox-wayland
    gnupg
    go_1_18
    jq
    light
    nix-direnv
    ossec
    pass
    ranger
    ripgrep
    rofi
    ssh-copy-id
    sway
    sway-contrib.grimshot
    swaycwd
    swayidle
    swaylock
    sysstat
    tmux
    tree
    unrar
    unzip
    wl-clipboard
    wlsunset
    yq
    zathura

    (writeShellScriptBin "jf" "exec docker run --rm -it --mount type=bind,source=\"$HOME/.jfrog\",target=/root/.jfrog 'releases-docker.jfrog.io/jfrog/jfrog-cli-v2-jf' jf \"$@\"")
    (writeShellScriptBin "list-git-vars" "${getExe bat} -l=ini --file-name 'git var -l (sorted)' <(${getExe git} var -l | sort)")
  ];

  users.users.${userName} = {
    initialPassword = "${userName}l33t${groupName}!";
    isNormalUser = true;
    group = groupName;
    extraGroups = ["users" "wheel" "systemd-journal"];
  };

  networking.nameservers = lib.mkForce ["127.0.0.1" "::1"];
  networking.resolvconf.enable = lib.mkForce false;
  networking.dhcpcd.extraConfig = lib.mkForce "nohook resolv.conf";
  networking.networkmanager.dns = lib.mkForce "none";
  systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = lib.mkForce "dnscrypt-proxy2";
  boot.kernelModules = ["kvm-intel" "br_netfilter"];
  services.earlyoom.enable = true;
  services.earlyoom.freeMemThreshold = 10;
  services.earlyoom.freeSwapThreshold = 10;
  services.journald.extraConfig = "\nSystemMaxUse=1G\n\n";
  services.journald.forwardToSyslog = false;
  console.earlySetup = true;
  console.useXkbConfig = true;
  programs.sway.enable = true;
  programs.mtr.enable = true;
  programs.xonsh.enable = true;
  programs.sway.extraOptions = ["--verbose" "--debug"];
  environment.variables.EDITOR = lib.mkForce "nvim";
  fileSystems."/" .fsType = "ext4";
  fileSystems."/".device = "/dev/disk/by-label/nixos";
  fileSystems."/boot".device = "/dev/disk/by-label/boot";
  fileSystems."/boot".fsType = "vfat";
  fonts.enableDefaultFonts = true;
  networking.interfaces.enp0s5.useDHCP = true;
  nix.allowedUsers = [userName];
  security.sudo.wheelNeedsPassword = lib.mkForce false;
  users.groups.${groupName} = {};
  users.groups.docker = {};
  users.groups.wheel = {};
}
