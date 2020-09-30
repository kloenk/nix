{ config, pkgs, lib, remap_win ? true, ... }:

{
  wayland.windowManager.sway = let
    wallpaper = "`find ${pkgs.wallpapers}/share/wallpapers/* | shuf -n 1`";
    systemd-run = "${pkgs.systemd}/bin/systemd-run --user --scope";
  in {
    enable = true;
    #systemdIntegration = true;
    config = {
      bars = [ ];
      input = {
        "*" = {
          xkb_layout = "de";
          xkb_variant = "neo";
          xkb_options = if remap_win then "altwin:swap_lalt_lwin" else "''";
        };
        "Wacom ISDv4 90 Pen".map_to_output = "'Unknown 0x02D8 0x00000000'";
      };
      output = {
        "*" = { background = "${wallpaper} fit #000000"; };
        "Lenovo Group Limited LEN T2224dA V5W53674" = { position = "0 0"; };
        "BenQ Corporation BenQ GL2450 P9D01467019" = { position = "1920 164"; };
        "Unknown 0x02D8 0x00000000" = {
          position = "0 0"; # FIXME: move possition depending on hostname
        };
      };
      modifier = "Mod4";
      workspaceAutoBackAndForth = true;
      window.titlebar = false;
      gaps = {
        inner = 0;
        smartBorders = "no_gaps";
        smartGaps = true;
      };
      terminal = "${systemd-run} ${pkgs.alacritty}/bin/alacritty";
      keybindings = let mod = config.wayland.windowManager.sway.config.modifier;
      in {
        "${mod}+Return" =
          "exec ${config.wayland.windowManager.sway.config.terminal}";
        "${mod}+Shift+q" = "kill";
        "${mod}+Shift+e" =
          "exec ${systemd-run} swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        "${mod}+Shift+c" = "reload";

        "${mod}+Print" = "exec --no-startup-id ${
            pkgs.writeShellScript "screenshot" ''
              PATH=${pkgs.libnotify}/bin:${pkgs.grim}/bin:${pkgs.slurp}/bin:$PATH

              scr="$HOME/Pictures/Screenshots/Screenshot-$(date "+%Y-%m-%d %H:%M:%S").png"
              mkdir -p "$(dirname "$scr")"
              grim -g "$(slurp)" "$scr"
              notify-send "Screenshot saved" "Screenshot saved to $scr"
            ''
          }";
        "${mod}+Shift+Print" = "exec --no-startup-id ${
            pkgs.writeShellScript "screenshot-all" ''
              PATH=${pkgs.libnotify}/bin:${pkgs.grim}/bin:$PATH

              scr="$HOME/Pictures/Screenshots/Screenshot-$(date "+%Y-%m-%d %H:%M:%S").png"
              mkdir -p "$(dirname "$scr")"
              grim "$scr"
              notify-send "Screenshot saved" "Screenshot saved to $scr"
            ''
          }";

        # movement
        "${mod}+Up" = "focus up";
        "${mod}+Down" = "focus down";
        "${mod}+Left" = "focus left";
        "${mod}+Right" = "focus right";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Right" = "move right";

        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        "${mod}+Shift+Space" = "floating toggle";
        "${mod}+Space" = "focus mode_toggle";

        "${mod}+d" =
          "exec --no-startup-id ${systemd-run} ${pkgs.wofi}/bin/wofi --show drun";

        # split
        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";

        # layout styles
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+f" = "fullscreen";
        "${mod}+a" = "focus parent";

        # scratchpad
        "${mod}+Shift+t" = "move scratchpad";
        "${mod}+t" = "scratchpad show";

        # move a workspace to another workspace (corresponds to the alt of F8)
        "${mod}+l" =
          "exec --no-startup-id ${systemd-run} ${pkgs.sway-cycle-workspace}";

        # FIXME: mod resize

        "XF86AudioRaiseVolume" =
          "exec --no-startup-id ${systemd-run} pactl set-sink-volume $(pacmd list-sinks |awk '/* index:/{print $3}') +5%";
        "XF86AudioLowerVolume" =
          "exec --no-startup-id ${systemd-run} pactl set-sink-volume $(pacmd list-sinks |awk '/* index:/{print $3}') -5%";
        "XF86AudioMute" =
          "exec --no-startup-id ${systemd-run} pactl set-sink-mute $(pacmd list-sinks |awk '/* index:/{print $3}') toggle";
        "XF86AudioMicMute" =
          "exec --no-startup-id ${systemd-run} pactl set-source-mute $(pacmd list-sources |awk '/* index:/{print $3}') toggle";
        "XF86MonBrightnessDown" =
          "exec --no-startup-id ${systemd-run} brightnessctl set 2%-";
        "XF86MonBrightnessUp" =
          "exec --no-startup-id ${systemd-run} brightnessctl set +2%";

        "${mod}+z" =
          "exec --no-startup-id ${systemd-run} ${pkgs.swaylock}/bin/swaylock -i ${wallpaper}";
      };
      startup = [ # TODO: scopes? could this run?
        {
          command = "${pkgs.waybar}/bin/waybar";
          always = false;
        }
        {
          command = ''
            ${pkgs.mako}/bin/mako --default-timeout 3000 --border-color "#ffffffff" --background-color "#00000070" --text-color "#ffffffff"'';
        }
        {
          command =
            "${pkgs.swayidle}/bin/swayidle -w timeout 300 '${pkgs.swaylock}/bin/swaylock -f -n -i ${wallpaper} -s fit; ${pkgs.sway}/bin/swaymsg \"output * dpms off\"' resume '${pkgs.sway}/bin/swaymsg \"output * dpms on\"' before-sleep '${pkgs.swaylock}/bin/swaylock -f -n -i ${wallpaper} -i fit'";
          always = false;
        }
        {
          command =
            "${pkgs.redshift}/bin/redshift -l 51.31:13.24 -t 5500:3700 -b 1:1";
          always = false;
        }
        {
          command =
            "${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY SWAYSOCK";
        }
        /* {
             command = "${pkgs.systemd}/bin/systemctl --user --start graphical-session.target";
           }
        */
      ];
    };
    extraConfig = ''
      # don't lock the screen if I'm watching TV
      for_window [app_id="firefox"] inhibit_idle fullscreen

      for_window [app_id="firefox" title="Firefox - Sharing Indicator"] floating enable
      for_window [app_id="firefox" title="Picture-in-Picture"] floating enable
      for_window [app_id="firefox" title="Picture-in-Picture"] sticky enable
    '';
    extraSessionCommands = ''
      		 # needs qt5.qtwayland in systemPackages
           export QT_QPA_PLATFORM=wayland QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
           export SDL_VIDEODRIVER=wayland MOZ_ENABLE_WAYLAND=1 BEMENU_BACKEND=wayland
           # Fix for some Java AWT applications (e.g. Android Studio),
           # use this if they aren't displayed properly:
           export _JAVA_AWT_WM_NONREPARENTING=1
          '';
  };
}
