self: let
  lib = self.inputs.nixpkgs.lib // self.lib;
  inherit (lib) mkForce mkDefault mkIf getExe;
  mkCSV = lib.concatStringsSep ",";
  configDir = "/media/psf/fnctl/fnctl/nix/os-configs/pvm";
  system = "aarch64-linux";
  hostName = "pvm";
  pkgData = with builtins; fromTOML (readFile ./pkgs.toml);
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
in
  lib.mkSystem rec {
    inherit system hostName;
    modules = [
      ({
        config,
        pkgs,
        lib,
        ...
      }: {
        disabledModules = ["virtualisation/parallels-guest.nix"];
        imports =
          [
            self.nixosModules.parallels
          ]
          ++ lib.optionals (builtins.pathExists ./internal.nix) [./internal.nix];

        nix.registry.nixpkgs.flake = self.inputs.nixpkgs;
        nix.registry.fnctl.flake = self;

        fonts.fonts = with pkgs; [
          terminus-nerdfont
          xkcd-font
          hack-font
        ];

        virtualisation.docker.rootless.package = pkgs.docker-edge;
        environment.systemPackages = with pkgs; [
          ossec
          aide
          sysstat
          docker-credential-helpers
          pass
          gnupg
          firefox-wayland

          alejandra
          jq
          yq
          ranger
          ripgrep
          nix-direnv
          ssh-copy-id
          tmux
          tree
          unrar
          unzip

          cage
          chromium
          qutebrowser
          wl-clipboard
          sway
          swaycwd
          alacritty
          wlsunset
          light
          rofi
          zathura
          swayidle
          swaylock
          wl-color-picker
          sway-contrib.grimshot

          (writeShellScriptBin "jf" "exec docker run --rm -it --mount type=bind,source=\"$HOME/.jfrog\",target=/root/.jfrog 'releases-docker.jfrog.io/jfrog/jfrog-cli-v2-jf' jf \"$@\"")
          (writeShellScriptBin "list-git-vars" "${getExe bat} -l=ini --file-name 'git var -l (sorted)' <(${getExe git} var -l | sort)")
        ];

        users.users.${userName} = {
          initialPassword = "${userName}l33t${groupName}!";
          isNormalUser = true;
          group = groupName;
          extraGroups = ["users" "wheel" "systemd-journal"];
        };

        networking.nameservers = mkForce ["127.0.0.1" "::1"];
        networking.resolvconf.enable = mkForce false;
        networking.dhcpcd.extraConfig = mkForce "nohook resolv.conf";
        networking.networkmanager.dns = mkForce "none";
        systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = mkForce "dnscrypt-proxy2";
        environment.shellAliases."system.sh" = "/media/psf/fnctl/systems/pvm/system.sh";
        environment.shellAliases."nvim" = "nix run /media/psf/fnctl/fnctl#astro-nvim";
        boot.kernelModules = ["kvm-intel" "br_netfilter"];
        services.earlyoom.enable = true;
        services.earlyoom.freeMemThreshold = 10;
        services.earlyoom.freeSwapThreshold = 10;
        services.journald.extraConfig = "\nSystemMaxUse=1G\n\n";
        services.journald.forwardToSyslog = false;
        virtualisation.docker.rootless.enable = true;
        virtualisation.docker.rootless.setSocketVariable = true;
        virtualisation.docker.rootless.daemon.settings.default-runtime = "runc";
        virtualisation.docker.rootless.daemon.settings.default-cgroupns-mode = "private";
        virtualisation.docker.rootless.daemon.settings.default-ipc-mode = "private";
        virtualisation.docker.rootless.daemon.settings.icc = false;
        virtualisation.docker.rootless.daemon.settings.experimental = true;
        system.activationScripts.chmod-etc-nixos = "chmod -R u+rw,g+r-w,o-rwx /etc/nixos /etc/nixos/.git/index";
        system.activationScripts.chown-etc-nixos = "chown -R ${userName}:${groupName} /etc/nixos /etc/nixos/.git/index";
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
        nixpkgs.overlays = [self.overlays.default];
        security.sudo.wheelNeedsPassword = lib.mkForce false;
        users.groups.${groupName} = {};
        users.groups.docker = {};
        users.groups.wheel = {};
      })
    ];
  }
