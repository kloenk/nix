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
  };

  # TODO:
  # services.postgresqlBackup.enable = true;
}
