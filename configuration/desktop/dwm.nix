{ config, pkgs, lib, ... }:

let 
  manager-dwm = import ../manager/dwm.nix { pkgs = pkgs; };
in {
    services.xserver = {
        enable = true;
        libinput.enable = true;
        libinput.tappingDragLock = true;
        displayManager.startx.enable = true;
    };

    services.dbus.packages = with pkgs; [ gnome3.dconf ];

    home-manager.users.kloenk = {
        #manager-dwm.home.file.".wallpaper-image-hdmi".source = ./wallpaper-image-hdmi.png;
        home = lib.recursiveUpdate manager-dwm.home { file.".wallpaper-image-hdmi".source = ./wallpaper-image-hdmi.png; };

        xsession = manager-dwm.xsession;

        services = manager-dwm.services;

        programs = manager-dwm.programs;
    };

    fonts.fonts = with pkgs; [ noto-fonts noto-fonts-emoji source-code-pro ];
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };
}
