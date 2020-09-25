{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.services.xonotic;

  toCfg = lib.generators.toKeyValue {
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString = v:
        if v == true then
          "1"
        else if v == false then
          "0"
        else if builtins.isString v then
          ''"${v}"''
        else
          lib.generators.mkValueStringDefault { } v;
    } " ";
  };

  toConfig = config: toCfg config;

  writeConfig = { config, extraConfig }:
    pkgs.writeText "server.cfg" ''
      ${toConfig config}
      ${extraConfig}
    '';

  serverModule = types.submodule ({ name, ... }: {
    options = {
      /* hostName = mkOption {
           type = types.str;
           description = "name of the server";
           default = name;
         };

         port = mkOption {
           readOnly = true;
           type = types.port;
           description = "server port";
           default = config.port;
         };
      */

      extraConfig = mkOption {
        type = types.lines;
        description = "server config written in server.cfg";
        example = ''
          duel
        '';
        default = "";
      };

      config = mkOption {
        type = types.attrsOf (types.oneOf [ types.str types.int types.bool ]);
        description =
          "server config. see https://github.com/xonotic/xonotic/wiki/basic-server-configuration";
        default = {
          hostname = name;
          port = 26000;
        };
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/xonotic/${name}";
        description = "directory for xonotic state";
      };

      package = mkOption {
        type = types.package;
        description = "xonotic package";
        default = pkgs.xonotic-dedicated;
      };
    };
  });
in {
  options = {
    services.xonotic = {
      servers = mkOption {
        type = types.attrsOf serverModule;
        default = { };
        description = "available servers";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/xonotic";
        description = "user home of the xonotic server user";
      };
    };
  };

  config = mkIf (cfg.servers != { }) {
    users.users.xonotic = {
      description = "xonetic server service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };

    systemd.services = (lib.mapAttrs' (name: config:
      let userDir = "${cfg.dataDir}/${name}";
      in lib.nameValuePair "xonotic-${name}" {
        description = "Xonotic server ${config.config.hostname}";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart =
            "${config.package}/bin/xonotic-dedicated -userdir ${userDir}";
          Restart = "always";
          User = "xonotic";
          WorkingDirectory = userDir;
        };

        preStart =
          let configFile = writeConfig { inherit (config) config extraConfig; };
          in ''
            mkdir -p ${userDir}/data/
            ln -sf ${configFile} ${userDir}/data/server.cfg
            chown -R xonotic ${userDir}
          '';
      }) cfg.servers);
  };
}
