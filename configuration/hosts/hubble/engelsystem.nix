{ pkgs, config, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureUsers = [
      {
        name = "engelsystem";
        ensurePermissions = {
          "engelsystem.*" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [
      "engelsystem"
    ];
  };

  services.engelsystem = {
    enable = true;
    domain = "punkte.kloenk.de";
    #database.host = ":/run/mysqld/mysqld.sock";
    database.host = "";
    #database.passwordFile??
    maintenance = false;
    mail = {
      driver = "smtp";
      from.address = "noreply-punkte@kloenk.de";
      from.name = "Abi 2021 Punktesystem";
      encryption = "tls";
      username = "noreply-punkte@kloenk.de";
      passwordFile = config.krops.secrets.files."es_mail_password".path;
    };
    autoarrive = true;
    minPasswordLength = 6;
    dect = false;
    userNames = true;
    plannedArrival = false;
    nightShifts.enable = false;
    defaultLocale = "de_DE";
  };

  krops.secrets.files."es_mail_password".owner = "engelsystem";
  users.users.engelsystem.extraGroups = [ "keys" "mysql" ];
}
