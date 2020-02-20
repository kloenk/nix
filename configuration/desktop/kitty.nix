{ config, pkgs, ... }:
 
{
  home-manager.users.kloenk = {
    home.packages = [ pkgs.kitty ];
    xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
  };
}
