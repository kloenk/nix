{ pkgs, lib, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_12;
    extraConfig = ''
      unix_socket_directories = '/run/postgresql/'
    '';

    ensureDatabases = [ "ve_collector" "kloenk" ];
    ensureUsers = [{
      name = "kloenk";
      ensurePermissions."DATABASE ve_collector" = "ALL PRIVILEGES";
      ensurePermissions."DATABASE kloenk" = "ALL PRIVILEGES";
    }];
  };
}
