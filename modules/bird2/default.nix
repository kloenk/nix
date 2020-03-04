{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types optionalString;

  optionalNullString = cond:
    string: if cond == null then "" else string;

  functionModule = types.submodule ({ name, ...}: {
    options = {
      body = mkOption {
        type = types.str;
        description = ''
          Function body
        '';
      };

      name = mkOption {
        type = types.str;
        description = ''
          function name
        '';
        default = name;
      };
    };
  });

  channelBlock = types.submodule ({ name, ... }: {
    options = {
      name = mkOption {
        type = types.enum [ "ipv4" "ipv6" ];
        default = name;
      };

      nextHop = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      keepFilterd = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      filter.import = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      filter.export = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };
  });
  formatChannel = channel: 
    ''
      ${channel.name} {
        ${optionalNullString channel.nextHop "next hop ${channel.nextHop};"}
        ${optionalNullString channel.keepFilterd "import keep filtered;"}
        ${optionalNullString channel.filter.import ''
          import filter {
            ${channel.filter.import}
          };
        ''}
        ${optionalNullString channel.filter.export ''
          export filter {
            ${channel.filter.export}
          };
        ''}
      };
    '';

  staticProtocolBlock = types.submodule ({ name, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };

      route = mkOption {
        type = types.str;
        description = "route to";
      };

      via = mkOption {
        type = types.str;
        description = "route via interface";
      };

      protocol = mkOption {
        type = types.enum [ "ipv4" "ipv6" ];
        description = "protocol for the static block";
      };

      body = mkOption {
        type = types.str;
        description = "FIXME: remove";
        default = "";
      };
    };
  });

  BGPProtocolBlock = types.submodule ({ name, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };

      as = mkOption {
        type = types.int;
        description = "local as number";
        default = cfg.as;
      };

      gracefulRestart = mkOption {
        type = types.bool;
        description = "enable graceful restart";
        default = true;
      };

      multihop = mkOption {
        type = types.nullOr types.int;
        description = "multihops";
        default = null;
      };

      channels = mkOption {
        type = types.loaOf channelBlock;
        default = {};
      };

      body = mkOption {
        type = types.str;
        description = "FIXME: remove";
        default = "";
      };
      
      neighbor.address = mkOption {
        type = types.nullOr types.str;
        description = "ip of the neighbor";
        default = null;
      };
      neighbor.as = mkOption {
        type = types.int;
        description = "the neigbor as number";
      };

      source = mkOption {
        type = types.nullOr types.str;
        description = "source address";
        default = null;
      };
    };
  });

  cfg = config.services.bird2;
  configFile = pkgs.writeTextFile {
    name = "bird2.conf";
    text = ''
      router id ${cfg.id};
      # functions
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: body: ''
        function ${body.name}() {
          ${body.body}
        }
      '') cfg.functions)}
      # protocol kernel
      # TODO
      # protocol static
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: proto: ''
        protocol static ${proto.name} {
          ${proto.protocol} {
            ${proto.body}
          };
          route ${proto.route} via "${proto.via}";
        }
      '') cfg.protocols.static)}
        # protocol bpg
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: proto: ''
            protocol bgp ${proto.name} {
            local as ${toString proto.as};
            ${optionalString proto.gracefulRestart "graceful restart on;"}
            ${if proto.multihop == null then "" else "multihop ${toString proto.multihop};"}
            ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: channel: ''
              ${formatChannel channel}
            '') proto.channels)}
            ${if proto.source == null then "" else "source address ${proto.source};"}
            ${if proto.neighbor.address == null then "" else "neighbor ${proto.neighbor.address} as ${toString proto.neighbor.as};"}
          }
        '') cfg.protocols.bgp)}
        ${cfg.extraConfig}
      '';
    checkPhase = ''
      ${pkgs.bird2}/bin/bird -d -p -c $out
    '';
  };

in {

  ###### interface
  options = {
    services.bird2 = {
      enable = mkEnableOption "BIRD Intrernet Routing Daemon (bird2)";

      functions = mkOption {
        type = types.loaOf functionModule;
        default = {};
      };

     protocols.static = mkOption {
       type = types.loaOf staticProtocolBlock;
       default = {};
     };

     protocols.bgp = mkOption {
       type = types.loaOf BGPProtocolBlock;
       default = {};
     };

      id = mkOption {
        type = types.str;
        example = "192.0.2.3";
      };

      as = mkOption {
        type = types.int;
        description = "local as number";
        example = 6500;
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = ''
          BIRD Internet Routing Daemon configuration file.
          <link xlink:href='http://bird.network.cz/'/>
        '';
      };


    };
  };


  ##### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.bird2 ];

    environment.etc."bird/bird2.conf".source = configFile;

    systemd.services.bird2 = {
      description = "BIRD Internet Routing Daemon (bird2)";
      wantedBy = [ "multi-user.target" ];
      reloadIfChanged = true;
      restartTriggers = [ config.environment.etc."bird/bird2.conf".source ];
      serviceConfig = {
        Type = "forking";
        Restart = "on-failure";
        ExecStart = "${pkgs.bird2}/bin/bird -c /etc/bird/bird2.conf -u bird -g bird";
        ExecReload = "${pkgs.bird2}/bin/birdc configure";
        ExecStop = "${pkgs.bird2}/bin/birdc down";
        CapabilityBoundingSet = [ "CAP_CHOWN" "CAP_FOWNER" "CAP_DAC_OVERRIDE" "CAP_SETUID" "CAP_SETGID"
                                  # see bird/sysdep/linux/syspriv.h
                                  "CAP_NET_BIND_SERVICE" "CAP_NET_BROADCAST" "CAP_NET_ADMIN" "CAP_NET_RAW" ];
        ProtectSystem = "full";
        ProtectHome = "yes";
        SystemCallFilter="~@cpu-emulation @debug @keyring @module @mount @obsolete @raw-io";
        MemoryDenyWriteExecute = "yes";
      };
    };

    users = {
      users.bird = {
        description = "BIRD Intrernet Routing Daemon user";
        group = "bird";
      };
      groups.bird = {};
    };
  };
}
