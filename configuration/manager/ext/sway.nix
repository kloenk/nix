{ pkgs, lib, ... }:

let
  config = (import ../../desktop/sway.nix { lib = lib; pkgs = pkgs; });
in {
  home.packages = config.users.users.kloenk.packages;
  wayland.windowManager.sway = {
    #enable = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export _JAVA_AWT_WM_NONREPARENTING=1
      #export GDK_BACKEND=wayland
    '';
  };
  home.file = config.home-manager.users.kloenk.home.file;
  xdg = config.home-manager.users.kloenk.xdg;
}
