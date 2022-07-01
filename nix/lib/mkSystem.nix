self: let
  nixpkgs = self.inputs.nixpkgs;
  nixosSystem = nixpkgs.lib.nixosSystem;
  lib = nixpkgs.lib // self.lib;
in
  # mkSystem builds a nixosSystem from the following arguments:
  args @ {
    system ?
      if builtins ? "currentSystem"
      then builtins.currentSystem
      else "aarch64-linux",
    modules ? [],
    stateVersion ? "22.05",
    withDocs ? false,
    withHomeManager ? false,
    hostName ? "fnctl",
    userName ? "developer",
    ...
  }:
    nixosSystem {
      inherit system;
      # specialArgs is for extra args (in addition to
      # config/options/pkgs/lib/etc.) that should be passed to the
      # nixosModules.
      specialArgs = {
        inherit nixpkgs system;
      };
      # modules is the list of nixosModules that should be merged (in order).
      modules = lib.concatLists [
        (lib.optionals withHomeManager [({...}: throw "home-manager is no longer supported, please disable withHomeManager in mkSystem.")])
        [
          ({pkgs, ...}:
            with lib; {
              nix.extraOptions = mkDefault ''experimental-features = nix-command flakes '';
              # add all inputs as cached registry entries for cached evaluations
              # and quick `nix search`, etc
              nix.registry = mapAttrs (_: flake: {inherit flake;}) self.inputs;
              # set the `NIX_PATH` so legacy nix commands use the same nixpkgs as
              # the new commands.
              nix.nixPath = mapAttrsToList (name: flake: "${name}=${flake}") self.inputs;
            })
          (_: {
            # disable features we'll never need...
            disabledModules = [
              "virtualisation/parallels-guest.nix"
            ];
            # ensure certain modules are available.
            boot.initrd.availableKernelModules = lib.mkAfter [
              "ahci"
              "nvme"
              "sd_mod"
              "sr_mod"
              "uhci_hcd"
              "usb_storage"
              "usbhid"
              "xhci_pci"
            ];
          })
          # other miscellaneous defaults ::
          ({pkgs, ...}:
            with lib; {
              boot.enableContainers = mkDefault true;
              boot.loader.efi.canTouchEfiVariables = mkDefault true;
              boot.loader.grub.configurationLimit = mkDefault 10;
              boot.loader.systemd-boot.enable = mkDefault true;
              boot.supportedFilesystems = mkDefault ["btrfs" "reiserfs" "vfat" "f2fs" "ext4"];
              console.earlySetup = mkDefault true;
              console.font = "Lat2-Terminus16";
              console.useXkbConfig = mkDefault true;
              documentation.dev.enable = mkDefault withDocs;
              documentation.doc.enable = mkDefault withDocs;
              documentation.info.enable = mkDefault withDocs;
              documentation.man.enable = mkDefault withDocs;
              documentation.man.generateCaches = mkDefault withDocs;
              documentation.man.man-db.enable = mkDefault withDocs;
              documentation.nixos.enable = mkDefault withDocs;
              environment.enableAllTerminfo = mkDefault true;
              environment.memoryAllocator.provider = mkDefault "libc";
              environment.variables.EDITOR = mkDefault "vim";
              hardware.gpgSmartcards.enable = mkDefault true;
              hardware.pulseaudio.enable = mkDefault true;
              hardware.video.hidpi.enable = mkDefault true;
              i18n.defaultLocale = mkDefault "en_US.UTF-8";
              networking.firewall.allowedTCPPorts = mkDefault [];
              networking.firewall.allowedUDPPorts = mkDefault [];
              networking.firewall.enable = mkForce true;
              networking.hostName = mkDefault hostName;
              nix.gc.automatic = true;
              nix.gc.dates = "daily";
              nix.gc.options = ''--max-freed "$((30 * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | ${pkgs.gawk}/bin/awk '{ print $4 }')))"'';
              nix.optimise.automatic = mkDefault true;
              nix.readOnlyStore = mkForce true;
              nix.requireSignedBinaryCaches = mkForce true;
              nix.settings.allowed-users = mkDefault ["@users"];
              nix.settings.auto-optimise-store = mkDefault true;
              nix.useSandbox = true;
              nixpkgs.config.allowUnfree = mkDefault true;
              nixpkgs.config.allowUnsupportedSystem = mkDefault true;
              powerManagement.cpuFreqGovernor = mkDefault "powersave";
              programs.git.config.alias.aliases = "config --show-scope --get-regexp alias";
              programs.git.config.alias.amend = "commit --amend";
              programs.git.config.alias.amendall = "commit --amend --all";
              programs.git.config.alias.amendit = "commit --amend --no-edit";
              programs.git.config.alias.branches = "branch --all";
              programs.git.config.alias.l = "log --pretty=oneline --graph --abbrev-commit";
              programs.git.config.alias.quick-rebase = "rebase --interactive --root --autosquash --autostash";
              programs.git.config.alias.remotes = "remote --verbose";
              programs.git.config.alias.user = "config --show-scope --get-regexp user";
              programs.git.config.alias.wtf-config = "config --show-scope --show-origin --list --includes";
              programs.git.config.apply.whitespace = "fix";
              programs.git.config.branch.sort = "-committerdate";
              programs.git.config.core.excludesfile = pkgs.writeText "git-excludes" (lib.concatStringsSep "\n" ["*~" "tags" ".nvimlog" "*.swp" "*.swo" "*.log" ".DS_Store"]);
              programs.git.config.core.ignorecase = true;
              programs.git.config.core.pager = lib.getExe pkgs.delta;
              programs.git.config.core.untrackedcache = true;
              programs.git.config.credential."https://github.com".helper = "${lib.getExe pkgs.gh} auth git-credential";
              programs.git.config.diff.bin.textconv = "hexdump -v -C";
              programs.git.config.diff.renames = "copies";
              programs.git.config.help.autocorrect = 1;
              programs.git.config.init.defaultbranch = "main";
              programs.git.config.interactive.difffilter = "${lib.getExe pkgs.delta} --color-only";
              programs.git.config.pull.ff = true;
              programs.git.config.pull.rebase = true;
              programs.git.config.push.default = "simple";
              programs.git.config.push.followtags = true;
              programs.git.enable = true;
              programs.git.lfs.enable = mkDefault true;
              programs.gnupg.agent.enable = mkDefault true;
              programs.gnupg.agent.enableSSHSupport = mkDefault true;
              programs.htop.enable = mkDefault true;
              programs.mtr.enable = mkDefault true;
              programs.neovim.defaultEditor = mkDefault true;
              programs.neovim.enable = mkDefault true;
              programs.neovim.viAlias = mkDefault true;
              programs.neovim.vimAlias = mkDefault true;
              programs.neovim.withNodeJs = mkDefault true;
              programs.neovim.withPython3 = mkDefault true;
              programs.neovim.withRuby = mkDefault true;
              programs.starship.enable = true;
              programs.starship.settings.add_newline = true;
              programs.starship.settings.character.error_symbol = "[➜](bold bright red)";
              programs.starship.settings.character.success_symbol = "[➜](bold bright green)";
              programs.starship.settings.scan_timeout = 10;
              programs.sway.wrapperFeatures.base = true;
              programs.sway.wrapperFeatures.gtk = true;
              programs.zsh.autosuggestions.enable = mkDefault true;
              programs.zsh.enable = mkDefault true;
              programs.zsh.enableBashCompletion = mkDefault true;
              programs.zsh.enableCompletion = mkDefault true;
              programs.zsh.enableGlobalCompInit = mkDefault true;
              programs.zsh.histFile = mkDefault "$HOME/.zsh_history";
              programs.zsh.histSize = mkDefault 10000;
              programs.zsh.syntaxHighlighting.enable = mkDefault true;
              security.allowSimultaneousMultithreading = mkDefault false;
              security.allowUserNamespaces = mkDefault true;
              security.forcePageTableIsolation = mkDefault true;
              security.lockKernelModules = mkDefault true;
              security.protectKernelImage = mkDefault true;
              security.rtkit.enable = mkDefault true;
              security.unprivilegedUsernsClone = mkForce true;
              security.virtualisation.flushL1DataCache = mkDefault "always";
              services.avahi.enable = mkForce false;
              services.fwupd.enable = mkDefault true;
              services.gnome.tracker-miners.enable = mkForce false;
              services.gnome.tracker.enable = mkForce false;
              services.haveged.enable = true;
              services.openssh.enable = mkDefault false;
              services.openssh.passwordAuthentication = mkForce false;
              services.pcscd.enable = true;
              services.printing.enable = mkForce false;
              sound.enable = mkDefault true;
              sound.mediaKeys.enable = mkDefault true;
              system.copySystemConfiguration = mkDefault false;
              system.nixos.tags = mkAfter ["fnctl"];
              system.stateVersion = mkDefault stateVersion;
              systemd.enableCgroupAccounting = mkDefault true;
              systemd.enableUnifiedCgroupHierarchy = mkDefault true;
              time.hardwareClockInLocalTime = mkDefault true;
              time.timeZone = mkDefault "America/New_York";
              users.allowNoPasswordLogin = mkDefault false;
              users.defaultUserShell = pkgs.zsh;
              users.enforceIdUniqueness = mkDefault true;
              users.groups.users = {};
              users.motd = mkDefault "Welcome to FnCtl!";
              users.mutableUsers = mkDefault true;
              users.users.root.initialPassword = mkDefault "";
            })
        ]
        (lib.optionals (args ? "modules" && lib.isList args.modules) args.modules)
      ];
    }
