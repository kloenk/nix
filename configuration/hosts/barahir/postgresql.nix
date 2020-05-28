{ pkgs, lib, ... }:

{
  fileSystems."/var/lib/postgresql" = {
    device = "/persist/data/postgresql";
    fsType = "none";
    options = [ "bind" ];
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_12;
    extraConfig = ''
      unix_socket_directories = '/run/postgresql/'
    '';
    ensureDatabases = [
      "ve_collector"
      "ve_collector_test"
      "gitlex"
      "gitlex_test"
      "gitlex_prod"
    ];
    ensureUsers = [{
      name = "kloenk";
      ensurePermissions."DATABASE ve_collector" = "ALL PRIVILEGES";
      ensurePermissions."DATABASE ve_collector_test" = "ALL PRIVILEGES";

      ensurePermissions."DATABASE gitlex" = "ALL PRIVILEGES";
      ensurePermissions."DATABASE gitlex_prod" = "ALL PRIVILEGES";
      ensurePermissions."DATABASE gitlex_test" = "ALL PRIVILEGES";
    }];
  };
}
