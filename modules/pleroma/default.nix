{ pkgs, lib, config, ... }:

let
  cfg = config.services.pleroma;
  configFile = if cfg.configFile != null then
    cfg.configFile
  else
    pkgs.writeText "pleroma-config.exs" cfg.configText;
  env = {
    PLEROMA_CONFIG_PATH = configFile;
    RELEASE_TMP = "/tmp";
    DOMAIN = cfg.domain;
  };
in {
  options.services.pleroma = with lib; {
    enable = mkEnableOption "Pleroma social network";
    domain = mkOption { type = types.str; };
    user = mkOption {
      type = types.str;
      default = "pleroma";
    };
    group = mkOption {
      type = types.str;
      default = "pleroma";
    };
    secretsEnvFile = mkOption { type = types.str; };
    package = mkOption {
      type = types.package;
      default = pkgs.pleroma;
    };
    configText = mkOption {
      type = with types; nullOr lines;
      default = null;
    };
    configFile = mkOption {
      type = with types; nullOr path;
      default = null;
    };
  };
  config = lib.mkIf cfg.enable {
    services.nginx.enable = true;
    services.nginx.virtualHosts = {
      "${cfg.domain}" = {
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:4000/";
            proxyWebsockets = true;
          };
          "/static/" = {
            root = cfg.package
              + "/lib/pleroma-${cfg.package.version}/priv/static/";
          };
        };
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "pleroma" ];
      /* ensureUsers = [
           {
             name = "pleroma";
             ensurePermissions."DATABASE pleroma" = "ALL PRIVILEGES";
           }
         ];
      */
    };

    users.groups.pleroma = lib.mkIf (cfg.group == "pleroma") { };
    users.users.pleroma = lib.mkIf (cfg.user == "pleroma") {
      isSystemUser = true;
      inherit (cfg) group;
    };

    systemd.services.pleroma-migrate = {
      serviceConfig.User = cfg.user;
      serviceConfig.Group = cfg.group;
      serviceConfig.PrivateTmp = true;
      serviceConfig.EnvironmentFile = cfg.secretsEnvFile;
      serviceConfig.StateDirectory = "pleroma";
      serviceConfig.Type = "oneshot";
      environment = env;
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${cfg.package}/bin/pleroma_ctl migrate
      '';
    };

    systemd.services.pleroma = {
      after = [ "pleroma-migrate.service" ];
      serviceConfig.User = cfg.user;
      serviceConfig.Group = cfg.group;
      serviceConfig.PrivateTmp = true;
      serviceConfig.EnvironmentFile = cfg.secretsEnvFile;
      serviceConfig.StateDirectory = "pleroma";
      environment = env;
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${cfg.package}/bin/pleroma start
      '';
    };

    environment.systemPackages = [ cfg.package ];
  };
}
