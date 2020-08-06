{ pkgs, config, ... }:

{
  services.engelsystem = {
    enable = true;
    domain = "punkte.kloenk.de";
    config = {
      maintenance = false;
      email = {
        driver = "smtp";
        from.address = "noreply-punkte@kloenk.de";
        from.name = "Abi 2021 Punktesystem";
        encryption = "tls";
        username = "noreply-punkte@kloenk.de";
        password._secret = config.krops.secrets.files."es_mail_password".path;
      };
      autoarrive = true;
      min_password_length = 6;
      enable_dect = false;
      enable_user_name = true;
      enable_planned_arrival = false;
      night_shifts.enabled = false;
      default_locale = "de_DE";
    };
  };

  krops.secrets.files."es_mail_password".owner = "engelsystem";
  users.users.engelsystem.extraGroups = [ "keys" ];
}
