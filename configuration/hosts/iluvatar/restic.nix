{ config, lib, pkgs, ... }:

{
  services.restic.backups.iluvatar = {
    initialize = true;
    passwordFile = config.krops.secrets.files."restic/password".path;
    paths = [
      "/var/lib/gitea"
      "/var/backup/postgresql"
      "/var/lib/postgresql"
      "/var/backup/mysql"
      "/var/lib/mysql"
      "/var/lib/bitwarden_rs/backup"
      "/var/lib/wordpress"
      "/persist/data/minecraft"
      "/persist"
    ];
    repository = "rclone:google:iluvatar";
  };

  systemd.services.restic-backups-iluvatar.path = [ pkgs.rclone ];
  systemd.services.restic-backups-iluvatar.preStart = lib.mkBefore (''
    mkdir -p /root/.config/rclone
    ln -sf ${
      config.krops.secrets.files."restic/rclone.conf".path
    } /root/.config/rclone/rclone.conf
  '');

  krops.secrets.files."restic/password".owner = "root";
  krops.secrets.files."restic/rclone.conf".owner = "root";
}
