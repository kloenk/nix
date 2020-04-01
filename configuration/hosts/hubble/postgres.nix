{ pkgs, lib, ... }:

{
  fileSystems."/var/lib/postgresql" = 
    { device = "/persist/data/postgresql";
      fsType = "none";
      options = [ "bind" ];
    };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_12;
    extraConfig = ''
      unix_socket_directories = '/run/postgresql/'
    '';
    authentication = lib.mkForce ''
      # Generated file; do not edit!
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust	
    '';
  };

  # TODO:
  # services.postgresqlBackup.enable = true;
}
