{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    guiAddress = "6.0.2.2:8384";
    openDefaultPorts = true;
    configDir = "/persist/data/syncthing/config";
    dataDir = "/persist/data/syncthing/data";
  };

  users.users.kloenk.extraGroups = [ "syncthing" ];

  networking.firewall.allowedTCPPorts = [ 8384 ];
}
