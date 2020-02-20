{ pkgs, ... }:

{
  programs.sway.enable = true;
  programs.sway.extraSessionCommands = ''
    export SDL_VIDEODRIVER=wayland
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export _JAVA_AWT_WM_NONREPARENTING=1
    #export GDK_BACKEND=wayland
  '';

  users.users.kloenk.packages = with pkgs; [
    (redshift.overrideAttrs (oldAttrs: {  # wayland redshift
      src = pkgs.fetchFromGitHub {
        owner = "minus7";
        repo = "redshift";
        rev = "eecbfedac48f827e96ad5e151de8f41f6cd3af66";
        sha256 = "0rs9bxxrw4wscf4a8yl776a8g880m5gcm75q06yx2cn3lw2b7v22";
      };
    }))
    wofi
    mako
    waybar
    swaylock
    brightnessctl
  ];

  fonts.fonts = with pkgs; [ dejavu_fonts liberation_ttf noto-fonts noto-fonts-emoji font-awesome_4 ];

  home-manager.users.kloenk = {
    xdg.configFile."sway/config".source = ./config.sway;
    xdg.configFile."waybar/config".source = ./config.waybar;
    xdg.configFile."waybar/style.css".source = ./style.waybar;
    xdg.configFile."quassel-irc.org/Dracula.qss".source = ./Dracula.qss;
    home.file.".wallpaper-image".source = ./wallpaper-image;
  };
}
