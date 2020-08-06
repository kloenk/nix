{ pkgs, config, ... }:

{

  fileSystems."/var/lib/mysql" = {
    device = "/persist/data/mysql";
    options = [ "bind" ];
  };
  systemd.services.mysql.unitConfig.RequiresMountFor = [ "/var/lib/mysql" ];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.mysqlBackup = { enable = true; };
}
