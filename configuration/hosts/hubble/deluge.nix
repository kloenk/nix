{ config, ... }:

{
  # stat dir
  fileSystems."/persist/deluge" = {
    device = "/dev/disk/by-uuid/0d7083c3-21d7-4d04-aefb-73119dd55e6e";
    fsType = "xfs";
  };

  fileSystems."/var/lib/deluge" = {
    device = "/persist/deluge";
    fsType = "none";
    options = [ "bind" ];
  };

  services.deluge2 = {
    enable = true;
    configureNginx = true;
    downloadsBasicAuthFile = config.krops.secrets.files."BasicAuth.deluge".path;
    web.enable = true;
    hostName = "hubble.kloenk.de";
  };

  krops.secrets.files."BasicAuth.deluge".owner = "nginx";
  users.users.nginx.extraGroups = [ "keys" ];

  /* services.nginx.virtualHosts."kloenk.de" = {
       enableACME = true;
       forceSSL = true;
     };
  */

  networking.firewall.allowedTCPPorts = [ 58846 60000 ];
  networking.firewall.allowedUDPPorts = [ 60000 ];
  networking.firewall.allowedTCPPortRanges = [{
    from = 6001;
    to = 6891;
  }];
  networking.firewall.allowedUDPPortRanges = [{
    from = 6001;
    to = 6891;
  }];
  services.ferm2.extraInput = "proto (tcp udp) dport (6001:6891) ACCEPT;";
}
