{ config, pkgs, lib, ... }:

{
  fileSystems."/var/lib/mysql" = {
    device = "/persist/data/mysql/";
    fsType = "none";
    options = [ "bind" ];
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    initialDatabases = [{ name = "if_flug"; }];
    ensureUsers = [{
      name = "kloenk";
      ensurePermissions = { "if_flug.*" = "ALL PRIVILEGES"; };
    }];
  };

  environment.systemPackages = with pkgs; [ mariadb ];
}
