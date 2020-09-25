{ config, ... }:

{
  fileSystems."/var/lib/deluge" = {
    device = "/persist/data/deluge";
    fsType = "none";
    options = [ "bind" ];
  };

  users.users.pbb.extraGroups = [ "deluge" ];
  users.users.kloenk.extraGroups = [ "deluge" ];
  services.deluge.enable = true;
  networking.firewall.allowedTCPPorts = [ 60000 ];
  networking.firewall.allowedUDPPorts = [ 60000 ];
}
