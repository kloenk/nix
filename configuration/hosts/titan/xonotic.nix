{ config, lib, pkgs, ... }:

{
  services.xonotic = {
    enable = true;
    servers."Kloenk-insta" = {
      hostName = "Kloenks nixos test server";
      options = ''
        sv_public 1
        +hook
        minplayers 2
        g_instagib 1
        g_instagib_blaster_keepforce 1
      '';
    };
  };
}
