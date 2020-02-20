{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.deluge2;
  cfg_web = config.services.deluge2.web;
  openFilesLimit = 4096;

in {
  options = {
    services = {
      deluge2 = {
        enable = mkEnableOption "Deluge daemon";

        openFilesLimit = mkOption {
          default = openFilesLimit;
          example = 8192;
          description = ''
            Number of files to allow deluged to open.
          '';
        };

        user = mkOption {
          type = types.str;
          default = "deluge";
          description = ''
            User under which deluge runs
            If it is set to "deluge", a user will be created.
          '';
        };

        group = mkOption {
          type = types.str;
          default = "deluge";
          description = ''
            Group under which deluge runs
            If it is set to "deluge", a group will be created.
          '';
        };

        package = mkOption {
          type = types.package;
          default = pkgs.deluge;
          description = "Deluge package";
        };

        hostName = mkOption {
            type = types.str;
            default = config.networking.hostName;
            description = "set hostname for nginx";
        };

        configureNginx = mkEnableOption "Use nginx to serve downloads directory";

        downloadsBasicAuthFile = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Basic Auth password file for the shelfie upload endpoint
          '';
        };
      };

      deluge2.web.enable = mkEnableOption "Deluge Web daemon";
    };
  };

  config = mkIf cfg.enable {

    systemd.services.deluged = {
      after = [ "network.target" ];
      description = "Deluge BitTorrent Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.deluge ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/deluged -d";
        # To prevent "Quit & shutdown daemon" from working; we want systemd to manage it!
        Restart = "on-success";
        User = cfg.user;
        Group = cfg.group;
        LimitNOFILE = cfg.openFilesLimit;
        WorkingDirectory = "/var/lib/deluge";
      };
    };

    systemd.services.delugeweb = mkIf cfg_web.enable {
      after = [ "network.target" ];
      description = "Deluge BitTorrent WebUI";
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];
      serviceConfig.ExecStart = "${cfg.package}/bin/deluge --ui web";
      serviceConfig.User = cfg.user;
      serviceConfig.Group = cfg.group;
    };

    users.users.deluge = mkIf (cfg.user == "deluge") {
      inherit (cfg) group;
      uid = config.ids.uids.deluge;
      home = "/var/lib/deluge";
      description = "Deluge Daemon user";
    };

    users.groups.deluge = mkIf (cfg.group == "deluge") {
      gid = config.ids.gids.deluge;
    };

    services.nginx = mkIf cfg.configureNginx {
      virtualHosts."${cfg.hostName}" = {
        locations."/Downloads/" = {
          root = "/var/lib/deluge";
          extraConfig = ''
            autoindex on;
            ${optionalString (cfg.downloadsBasicAuthFile != null) ''
              auth_basic secured;
              auth_basic_user_file ${cfg.downloadsBasicAuthFile};
            ''}
          '';
        };
      };
    };
  };
}