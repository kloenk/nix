{ config, pkgs, lib, ... }:

{

  fileSystems."/var/lib/bitwarden_rs" =
    { device = "/persist/data/bitwarden_rs";
      fsType = "none";
      options = [ "bind" ];
    };

  services.bitwarden_rs = {
    enable = true;
    backupDir = "/var/lib/bitwarden_rs/backup";
    config = {
      domain = "https://bitwarden.kloenk.de";
      signupsAllowed = true;
      rocketPort = 8222;
      rocketLog = "critical";
    };
  };

  services.nginx.virtualHosts."bitwarden.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    # Allow large attachments
    extraConfig = "client_max_body_size 128M;";
    locations."/".proxyPass = "http://127.0.0.1:8222/";
  };
}
