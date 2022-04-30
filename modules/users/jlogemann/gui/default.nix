{ self, config, lib, pkgs, home-manager, unstable, ... }: with lib; {
  options.users.jlogemann.gui =  let inherit(lib) mkOption types; in {
    enable = mkEnableOption "enable very opinionated i3 config";

    defaultFont = mkOption {
      default = "FuraCode Nerd Font Mono";
      description = "Default font to use for i3 (preferably monospace with patched icons).";
      type = types.str;
    };

    defaultFontSize = mkOption {
      default = "16";
      description = "Default font to use for i3 (preferably monospace with patched icons).";
      type = types.str;
    };

    extraStartupCommands = mkOption {
      description = "Extra commands to 'exec_always' in i3wm.";
      type = with types; listOf str;
      default = [];
    };

    defaultMonitor = mkOption {
      default = "eDP-1";
      description = "Default xrandr output to set upon i3 restart.";
      type = types.str;
    };

    defaultApps = {
      browser = mkOption {
        description = "Which browser should be pre-configured as the default?";
        default = "firefox";
        type = types.enum [ "firefox" "chromium-browser" "google-chrome" "qutebrowser" ];
      };

      editor = mkOption {
        description = "Which graphical editor should be pre-configured as the default?";
        default = "code";
        type = types.enum [ "code" "nvim"  "gnvim" ];
      };

      terminal = mkOption {
        description = "Which graphical terminal should be pre-configured as the default?";
        default = "alacritty";
        type = types.enum [ "alacritty" "kitty" ];
      };
    };

    colors =
      let
        colorOption = ident: default: mkOption {
          inherit default;
          description = "Hexadecimal 256-color code for ${ident} (without leading #).";
          type = types.str;
        };
      in {
        bg = colorOption "bg" "222222";
        fg = colorOption "fg" "EAEAEA";
        bright    = {
          black   = colorOption "bright black"   "161616";
          red     = colorOption "bright red"     "e84f4f";
          green   = colorOption "bright green"   "b7ce42";
          yellow  = colorOption "bright yellow"  "fea63c";
          blue    = colorOption "bright blue"    "66aabb";
          magenta = colorOption "bright magenta" "b7416e";
          cyan    = colorOption "bright cyan"    "6d878d";
          white   = colorOption "bright white"   "dddddd";
        };
        normal    = {
          black   = colorOption "black"   "666666";
          red     = colorOption "red"     "d23d3d";
          green   = colorOption "green"   "bde077";
          yellow  = colorOption "yellow"  "ffe863";
          blue    = colorOption "blue"    "aaccbb";
          magenta = colorOption "magenta" "e16a98";
          cyan    = colorOption "cyan"    "42717b";
          white   = colorOption "white"   "cccccc";
        };
      };
    };

    config = let 
      cfg = config.base.gui; 
      wrappers = pkgs.callPackage ./wrappers.nix {};
      exec = cmd: "exec \"${cmd}\"";
      mode = name: "mode \"${name}\"";
      exec_always = cmd: "exec_always \"${cmd}\"";

      i3Config = (pkgs.lib.concatStringsSep "\n" ([
        "set $mod Mod4"  /* Mod4 is Super aka. "The Command Key" or "The Windows Key". */
        "floating_modifier $mod"
        "force_focus_wrapping yes"
        "focus_follows_mouse no"
        "mouse_warping output"
        "popup_during_fullscreen smart"
        "force_display_urgency_hint 1000 ms"
        "workspace_auto_back_and_forth yes"
        "show_marks yes"
        "new_window pixel 4"
        "ipc-socket ~/.i3/i3-ipc.sock"
        "font pango:${cfg.defaultFont} ${cfg.defaultFontSize}"
        "hide_edge_borders smart"
        "smart_borders on"
        "smart_gaps enable"
        "gaps inner ${cfg.defaultFontSize}"
        "gaps outer ${cfg.defaultFontSize}"] 

        ++ [
          /* (exec_always "xrdb -merge /etc/i3/Xresources") */
          (exec_always "setxkbmap -option '' -option 'ctrl:nocaps'")
          (exec_always "xset s off -dpms")  # disable Display Power Management System.
          (exec_always "${wrappers}/bin/redshift.sh")
          (exec_always "${wrappers}/bin/compton.sh")
          (exec_always "${wrappers}/bin/feh.sh")
          (exec_always "${wrappers}/bin/dunst.sh")
          /* Fix a bug in gnome-settings-daemon:
          **   ref: http://feeding.cloud.geek.nz/posts/creating-a-modern-tiling-desktop-environment-using-i3/
          *  (exec_always "dconf write /org/gnome/settings-daemon/plugins/cursor/active false") */
          ]

          ++ (with cfg.colors; [
            /* ---------------- *
            ** Theme Settings  **
            * ---------------- */
            /* window class           border             backgr.            text    indicator */
            "client.focused           #${bright.blue}    #${bright.blue}    #${fg}  #${bright.blue}"
            "client.focused_inactive  #${normal.blue}    #${normal.blue}    #${fg}  #${normal.blue}"
            "client.unfocused         #${bg}             #${bg}             #${fg}  #${bg}"
            "client.urgent            #${bright.yellow}  #${normal.yellow}  #${bg}  #${bright.yellow}"
            "client.background        #${bg}"
            /* --------------------- *
            ** Status Bar Settings  **
            * --------------------- */
            "bar {"
            "  position top"
            "  status_command ${pkgs.i3status}/bin/i3status -c /etc/i3status.conf"
            "  colors {"
            "    background   #${bg}"
            "    statusline   #${fg}"
            "    separator    #${bright.black}"
            "    active_workspace     #${normal.blue}    #${bright.blue}    #${fg}"
            "    focused_workspace    #${bright.blue}    #${normal.blue}    #${bg}"
            "    inactive_workspace   #${bg}             #${bg}             #${fg}"
            "    urgent_workspace     #${bright.yellow}  #${normal.yellow}  #${bg}"
            "  }"
            "  workspace_buttons yes"
            "  font \"pango:${cfg.defaultFont} ${cfg.defaultFontSize}\""
            "}"
            ]) 

            /* --------------------- *
            **      Keybinds        **
            * --------------------- */
            ++ [ "bindsym $mod+1            workspace   1"
            "bindsym $mod+2            workspace   2"
            "bindsym $mod+3            workspace   3"
            "bindsym $mod+4            workspace   4"
            "bindsym $mod+5            workspace   5"
            "bindsym $mod+6            workspace   6"
            "bindsym $mod+7            workspace   7"
            "bindsym $mod+8            workspace   8"
            "bindsym $mod+9            workspace   9"
            "bindsym $mod+0            scratchpad  show"
            "bindsym $mod+Tab          workspace   next_on_output"
            "bindsym $mod+grave        workspace   back_and_forth"
            "bindsym $mod+Shift+Tab    workspace   prev_on_output"
            "bindsym $mod+Ctrl+Escape  exit"
            "bindsym $mod+Ctrl+d       floating    toggle"
            "bindsym $mod+Ctrl+f       fullscreen  toggle"
            "bindsym $mod+Ctrl+h       resize      shrink width  4 px or 4 ppt"
            "bindsym $mod+Ctrl+j       resize      grow   height 4 px or 4 ppt"
            "bindsym $mod+Ctrl+k       resize      shrink height 4 px or 4 ppt"
            "bindsym $mod+Ctrl+l       resize      grow   width  4 px or 4 ppt"
            "bindsym $mod+Ctrl+r       reload"
            "bindsym $mod+Escape       exec ${pkgs.i3lock}/bin/i3lock -c ${cfg.colors.bg}"
            "bindsym $mod+Shift+1      move        workspace 1"
            "bindsym $mod+Shift+2      move        workspace 2"
            "bindsym $mod+Shift+3      move        workspace 3"
            "bindsym $mod+Shift+4      move        workspace 4"
            "bindsym $mod+Shift+5      move        workspace 5"
            "bindsym $mod+Shift+6      move        workspace 6"
            "bindsym $mod+Shift+7      move        workspace 7"
            "bindsym $mod+Shift+8      move        workspace 8"
            "bindsym $mod+Shift+9      move        workspace 9"
            "bindsym $mod+Shift+0      move        scratchpad"
            "bindsym $mod+Shift+h      move        left"
            "bindsym $mod+Shift+j      move        down"
            "bindsym $mod+Shift+k      move        up"
            "bindsym $mod+Shift+l      move        right"
            "bindsym $mod+Shift+q      exec xkill"
            /* "bindsym $mod+a            ${mode      "App Mode"}"
            "bindsym $mod+backslash    ${mode      "Layout Mode"}"*/
            "bindsym $mod+e            exec gnvim"
            "bindsym $mod+f            exec \"${wrappers}/bin/filemanager.sh\"" 
            "bindsym $mod+h            focus       left"
            "bindsym $mod+i            split       h"
            "bindsym $mod+q            kill"
            "bindsym $mod+b            bar         mode toggle"
            "bindsym $mod+j            focus       down"
            "bindsym $mod+k            focus       up"
            "bindsym $mod+l            focus       right"
            "bindsym $mod+r            exec \"${wrappers}/bin/rofi.sh -show drun\""
            "bindsym $mod+space        exec \"${wrappers}/bin/rofi.sh -show combi\""
            "bindsym $mod+t            exec \"${wrappers}/bin/terminal.sh"
            "bindsym $mod+v            split       v"
            "bindsym $mod+w            exec ${pkgs.chromium}/bin/chromium" 
          ]));

          i3StatusConfig = ''
            general {
             output_format = "i3bar"
             colors = true
             interval = 5
            }

            order += "tztime local"
            order += "memory"
            order += "load"
            order += "wireless _first_"
            order += "ethernet _first_"
            order += "disk /"
            order += "battery 0"

            wireless _first_ {
           align = "left"
           format_up = "%essid"
           format_down = ""
            }

            ethernet _first_ {
                 format_up = "%ip (%speed)"
                 format_down = ""
            }

            battery 0 {
                 format = "%status %emptytime"
                 format_down = "X"
                 status_chr = "⚡"
                 status_bat = "🔋"
                 status_unk = "?"
                 status_full = "☻"
                 path = "/sys/class/power_supply/BAT%d/uevent"
                 low_threshold = 10
            }

            run_watch DHCP {
                 pidfile = "/var/run/dhclient*.pid"
            }

            run_watch VPNC {
                 pidfile = "/var/run/vpnc/pid"
            }

            path_exists VPN {
                 path = "/proc/sys/net/ipv4/conf/tun0"
            }

            tztime local {
                 format = "%H:%M"
            }

            load {
                 format = "%5min"
            }

            cpu_temperature 0 {
                 format = "T: %degrees °C"
                 path = "/sys/devices/platform/coretemp.0/temp1_input"
            }

            memory {
                 format = "%used"
                 threshold_degraded = "10%"
                 format_degraded = "MEMORY: %free"
            }

            disk "/" {
                 format = "%free"
            }

            read_file uptime {
                 path = "/proc/uptime"
            }
          '';

    in mkIf cfg.enable {
      environment.etc = {
        "i3/config" = mkForce { text = i3Config; };
        "i3status.conf" = mkForce { text = i3StatusConfig; };
      };
      fonts.fontDir.enable = true;
      fonts.fonts = with pkgs; mkAfter [ terminus-nerdfont ];
      services.xserver = {
        enable                         = mkForce true;
        autorun                        = mkForce true;
        exportConfiguration            = mkForce true;
        updateDbusEnvironment          = mkForce true;
        displayManager.sddm.enable     = mkForce false;
        displayManager.lightdm.enable  = mkForce true;
        displayManager.gdm.enable      = mkForce false;
        displayManager.gdm.wayland     = mkForce false;
        windowManager.i3.enable        = mkForce true;
        windowManager.i3.package       = mkForce pkgs.i3-gaps;
        windowManager.i3.configFile    = mkForce "/etc/i3/config";
        windowManager.i3.extraPackages = with pkgs; [
            alacritty kitty
            arandr
            desktop-file-utils
            dmenu
            firefox
            libnotify
            maim
            rofi rofi-menugen rofi-pass rofi-systemd
            ranger
            i3lock
            scrot
            slock
            sxiv
            wmctrl
            xclip
            xdg-launch xdg-user-dirs xdg-utils
            xdo xdotool xsel
            zathura
          ];
      };
  };
}
