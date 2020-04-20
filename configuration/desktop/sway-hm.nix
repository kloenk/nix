{ config, pkgs, lib, remap_win ? true, ... }:

{
  wayland.windowManager.sway = let
    wallpaper = "`find ${pkgs.wallpapers}/share/wallpapers/* | shuf -n 1`";
  in {
    enable = true;
    config = {
      bars = [];
      input = {
        "*" = {
          xkb_layout = "de";
          xkb_variant = "neo";
          xkb_options = if remap_win then "altwin:swap_lalt_lwin" else "''";
        };
      };
      output = {
        "*" = {
          background = "${wallpaper} fit #000000"; 
        };
        "Lenovo Group Limited LEN T2224dA V5W53674" = {
          position = "0 0";
        };
        "BenQ Corporation BenQ GL2450 P9D01467019" = {
          position = "1920 164";
        };
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
      terminal = "${pkgs.alacritty}/bin/alacritty";
      keybindings = let mod = config.wayland.windowManager.sway.config.modifier; in {
        "${mod}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
        "${mod}+Shift+q" = "kill";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        "${mod}+Shift+c" = "reload";

				"${mod}+Print" = "exec --no-startup-id ${pkgs.writeShellScript "screenshot" ''
          PATH=${pkgs.libnotify}/bin:${pkgs.grim}/bin:${pkgs.slurp}/bin:$PATH

          scr="$HOME/Pictures/Screenshots/Screenshot-$(date "+%Y-%m-%d %H:%M:%S").png"
          mkdir -p "$(dirname "$scr")"
          grim -g "$(slurp)" "$scr"
          notify-send "Screenshot saved" "Screenshot saved to $scr"
        ''}";
				"${mod}+Shift+Print" = "exec --no-startup-id ${pkgs.writeShellScript "screenshot-all" ''
          PATH=${pkgs.libnotify}/bin:${pkgs.grim}/bin:$PATH

          scr="$HOME/Pictures/Screenshots/Screenshot-$(date "+%Y-%m-%d %H:%M:%S").png"
          mkdir -p "$(dirname "$scr")"
          grim "$scr"
          notify-send "Screenshot saved" "Screenshot saved to $scr"
        ''}";

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

        "${mod}+d" = "exec --no-startup-id ${pkgs.wofi}/bin/wofi --show drun";

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

        # FIXME: mod resize

        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume $(pacmd list-sinks |awk '/* index:/{print $3}') +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume $(pacmd list-sinks |awk '/* index:/{print $3}') -5%";
        "XF86AudioMute" = "exec pactl set-sink-mute $(pacmd list-sinks |awk '/* index:/{print $3}') toggle";
        "XF86AudioMicMute" = "exec pactl set-source-mute $(pacmd list-sources |awk '/* index:/{print $3}') toggle";
        "XF86MonBrightnessDown" = "exec brightnessctl set 2%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set +2%";

        "${mod}+z" = "exec ${pkgs.swaylock}/bin/swaylock -i ${wallpaper}";
      };
      startup = [
        { command = "${pkgs.waybar}/bin/waybar"; always = false; }
        { command = "${pkgs.mako}/bin/mako --default-timeout 3000 --border-color \"#ffffffff\" --background-color \"#00000070\" --text-color \"#ffffffff\""; }
        { command = "${pkgs.swayidle}/bin/swayidle -w timeout 300 '${pkgs.swaylock}/bin/swaylock -f -n -i ${wallpaper} -s fit; ${pkgs.sway}/bin/swaymsg \"output * dpms off\"' resume '${pkgs.sway}/bin/swaymsg \"output * dpms on\"' before-sleep '${pkgs.swaylock}/bin/swaylock -f -n -i ${wallpaper} -i fit'"; always = false; }
        { command = "${pkgs.redshift}/bin/redshift -l 51.31:13.24 -t 5500:3700 -b 1:1"; always = false; }

      ];
    };
    extraSessionCommands = ''
		 # needs qt5.qtwayland in systemPackages
     #export QT_QPA_PLATFORM=wayland QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
     #export SDL_VIDEODRIVER=wayland MOZ_ENABLE_WAYLAND=1 BEMENU_BACKEND=wayland
     # Fix for some Java AWT applications (e.g. Android Studio),
     # use this if they aren't displayed properly:
     export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };
}
