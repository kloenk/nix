{ lib, config, ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    #configDir = "/persist/data/syncthing/config";
    configDir = lib.mkDefault "${config.services.syncthing.dataDir}/conf";
  };

  users.users.kloenk.extraGroups = [ "syncthing" ];
}
