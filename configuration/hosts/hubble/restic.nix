{ config, lib, pkgs, ... }:

{
  services.restic.backups.hubble = {
    initialize = true;
    passwordFile = config.krops.secrets.files."restic/password".path;
    paths = [
      "/var/vmail"
      "/var/dkim"
      "/var/lib/mysql"
      "/var/backup/mysql"
      "/var/lib/postgresql"
      "/var/backup/postgresql"
    ];
    repository = "rclone:google:restic-nixos";
  };

  systemd.services.restic-backups-hubble.path = [ pkgs.rclone ];
  systemd.services.restic-backups-hubble.preStart = lib.mkBefore (''
    mkdir -p /root/.config/rclone
    ln -s ${
      config.krops.secrets.files."restic/rclone.conf".path
    } /root/.config/rclone/rclone.conf
  '');

  krops.secrets.files."restic/password".owner = "root";
  krops.secrets.files."restic/rclone.conf".owner = "root";
}
