{ pkgs, ... }:

let 
  home = {
      keyboard = {
        layout = "de";
        options = [ "altwin:swap_lalt_lwin" ];
      };
      file = {
        ".wallpaper-image".source = ../desktop/wallpaper-image;
        ".config/quassel-irc.org/Dracula.qss".source = ../desktop/Dracula.qss;
        ".Xresources".source = ../desktop/Xresources;
      };
  };

  xsession = {
      enable = true;
      scriptPath = ".xinitrc";
      windowManager.command = "${pkgs.dwm}/bin/dwm";
      initExtra = ''
        ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources
        ${pkgs.feh}/bin/feh --bg-fill ~/.wallpaper-image
        ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr &

        export XDB_SESSION_TYPE=x111
        export KDE_FULL_SESSION=true
        export XDG_CURRENT_DESKTOP=KDE
        export GPG_TTY=$(tty)

        ${pkgs.notify-osd}/bin/notify-osd &

        ${pkgs.slstatus}/bin/slstatus &
      '';
  };

  services = {
    compton = {
      enable = true;
      backend = "glx";
      shadow = true;
      shadowOpacity = "0.3";
    };

    redshift = {
      enable = true;
      latitude = "51.085636";
      longitude = "7.1105932";
    };
  };

  programs = {
    fish.shellAbbrs.startx = "exec startx";

    rofi = {
      enable = true;
      padding = 15;
      font = "DejaVu Sans 13";
      scrollbar = false;
      terminal = "${pkgs.termite}/bin/termite";
      theme = "${pkgs.rofi}/share/rofi/themes/Arc-Dark.rasi";
      extraConfig = ''
          rofi.fake-transparency: true
          rofi.show-icons: true
          rofi.modi: combi,drun,ssh,window
          rofi.combi-modi: drun,ssh,window
          rofi.sidebar-mode: true
          rofi.auto-select: false
          rofi.ssh-command: ${pkgs.termite}/bin/termite -e "${pkgs.openssh}/bin/ssh {host}"

          rofi.color-window:      argb:e0000000,argb:00000000,argb:00000000
          rofi.color-normal:      argb:00000000,#ffffff,argb:00000000,argb:00000000,#567eff
      '';
    };
  };

in {
    inherit home xsession services programs;
}
