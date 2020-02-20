{ config, ... }:

{
  services.deluge2 = {
    enable = true;
    configureNginx = true;
    downloadsBasicAuthFile = config.krops.secrets.files."BasicAuth.deluge".path;
    web.enable = true;
    hostName = "kloenk.de";
  };

  krops.secrets.files."BasicAuth.deluge".owner = "nginx";
  users.users.nginx.extraGroups = [ "keys" ];

  services.nginx.virtualHosts."kloenk.de" = {
    enableACME = true;
    forceSSL = true;
  };

  systemd.services.deluge-init = {
    script = ''
      mkdir -p /data/deluge
      chown deluge:deluge /data/deluge
      [ -e /var/lib/deluge ] || ln -s /data/deluge /var/lib/deluge
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    after = [ "network.target" ];
    before = [ "deluged.service" ];
    wantedBy = [ "multi-user.target" ];
  };

  networking.firewall.allowedTCPPorts = [ 58846 60000 ];
  networking.firewall.allowedUDPPorts = [ 60000 ];
  networking.firewall.allowedTCPPortRanges = [ { from = 6001; to = 6891; } ];
  networking.firewall.allowedUDPPortRanges = [ { from = 6001; to = 6891; } ];
  services.ferm2.extraInput = "proto (tcp udp) dport (6001:6891) ACCEPT;";
}
