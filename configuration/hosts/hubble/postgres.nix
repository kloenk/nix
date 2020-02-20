{ pkgs, lib, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
    authentication = lib.mkForce ''
      # Generated file; do not edit!
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
      host    all             all             192.168.42.0/24         trust
    '';
  };

  services.postgresql.initialScript = pkgs.writeText "postgres-initScript" ''
    CREATE ROLE quassel LOGIN CREATEDB;
    CREATE DATABASE quassel;
    GRANT ALL PRIVILEGES ON DATABASE quassel TO quassel;
    CREATE ROLE netbox LOGIN CREATEDB;
    CREATE DATABASE netbox;
    GRANT ALL PRIVILEGES ON DATABASE netbox TO netbox;
    CREATE ROLE gitea LOGIN CREATEDB;
    CREATE DATABASE gitea;
    GRANT ALL PRIVILEGES ON DATABASE gitea TO gitea;
    CREATE ROLE grafana LOGIN CREATEDB;
    CREATE DATABASE grafana;
    GRANT ALL PRIVILEGES ON DATABASE grafana TO grafana;
  '';

  systemd.services.postgresql.serviceConfig.TimeoutSec = lib.mkForce 600;

  systemd.services.quassel.after = [ "postgresql.service" ];
  systemd.services.gitea.after = [ "postgresql.service" ];
  systemd.services.grafana.after = [ "postgresql.service" ];

}
