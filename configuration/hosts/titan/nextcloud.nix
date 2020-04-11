{ config, lib, pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    config.adminpass = "foobar";

    config.dbhost = "/var/lib/nextcloud/db.sqlite3";
    config.dbtype = "sqlite";

    config.overwriteProtocol = "https";
    https = true;

    hostName = "klaut.kloenk.de";
    nginx.enable = true;

    # initial sign docs?
    # skeletonDirectory = 
  };

  # nginx cert auth
  services.nginx.appendHttpConfig = ''
    map $ssl_client_s_dn $ssl_client_s_dn_cn {
      default "invalid";
      ~,CN=(?<CN>[^,]+) $CN;
    }
  '';
  services.nginx.virtualHosts."klaut.kloenk.de" = {
    locations."~ ^\\/(?:index|remote|public|cron|core/ajax\\/update|status|ocs\\/v[12]|updater\\/.+|ocs-provider\\/.+|ocm-provider\\/.+)\\.php(?:$|\\/)".extraConfig = ''
      fastcgi_param REMOTE_USER $ssl_client_s_dn_cn;
    '';
    extraConfig = ''
      ssl_client_certificate ${<configuration/files/nyantec_Root_CA.pem>};
      ssl_verify_client on;
      ssl_verify_depth 1;
    '';
    enableACME = true;
    forceSSL = true;
  };
}
