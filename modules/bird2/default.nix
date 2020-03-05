{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types optionalString;

  optionalNullString = cond:
    string: if cond == null then "" else string;

  mkStrOption = description: mkOption {
    type = types.nullOr types.str;
    default = null;
    description = description;
  };

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
        type = types.enum [ "ipv4" "ipv6" ]; # TODO: ??
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

      sadr = mkOption {
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
  formatChannel = channel: ''
      ${channel.name} ${optionalNullString channel.sadr channel.sadr} {
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

  babelProtocolBlock = types.submodule ({ name, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };

      template = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      channels = mkOption {
        type = types.loaOf channelBlock;
        default = {};
      };

      radomeizedID = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      interface.pattern = mkStrOption ''interface pattern'';

      interface.type = mkOption {
        type = types.nullOr types.enum [ "wired" "wireless" ];
        default = null;
        description = ''
          This option specifies the interface type: Wired or wireless.
          On wired interfaces a neighbor is considered unreachable after a small number of Hello packets are lost,
          as described by limit option. On wireless interfaces the ETX link quality estimation technique is used
          to compute the metrics of routes discovered over this interface. This technique will gradually degrade
          the metric of routes when packets are lost rather than the more binary up/down mechanism of wired type links.
          Default: wired.
        '';
      };

      interface.rxcost = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          This option specifies the nominal RX cost of the interface.
          The effective neighbor costs for route metrics will be computed from this value with a mechanism determined
          by the interface type. Note that in contrast to other routing protocols like RIP or OSPF, the rxcost
          specifies the cost of RX instead of TX, so it affects primarily neighbors' route selection and not local
          route selection.
          Default: 96 for wired interfaces, 256 for wireless.
        '';
      };
      
      interface.limit = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          BIRD keeps track of received Hello messages from each neighbor to establish neighbor reachability.
          For wired type interfaces, this option specifies how many of last 16 hellos have to be correctly received in
          order to neighbor is assumed to be up. The option is ignored on wireless type interfaces, where gradual cost
          degradation is used instead of sharp limit.
          Default: 12.
        '';
      };

      helloInterval = mkStrOption ''
        Interval at which periodic Hello messages are sent on this interface, with time units.
        Default: 4 seconds.
      '';

      updateInterval = mkStrOption ''
        Interval at which periodic (full) updates are sent, with time units.
        Default: 4 times the hello interval.
      '';

      port = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          This option selects an UDP port to operate on.
          The default is to operate on port 6696 as specified in the Babel RFC.
        '';
      };

      txClass = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          This option specify the ToS/DiffServ/Traffic class/Priority of the outgoing Babel packets.
          See tx class common option for detailed description.
        '';
      };
      txDscp = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          This option specify the ToS/DiffServ/Traffic class/Priority of the outgoing Babel packets.
          See tx class common option for detailed description.
        '';
      };
      txPriority = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          This option specify the ToS/DiffServ/Traffic class/Priority of the outgoing Babel packets.
          See tx class common option for detailed description.
        '';
      };

      rxBuffer = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          This option specifies the size of buffers used for packet processing.
          The buffer size should be bigger than maximal size of received packets.
          The default value is the interface MTU, and the value will be clamped to a minimum of
          512 bytes + IP packet overhead.
        '';
      };

      txLength = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          This option specifies the maximum length of generated Babel packets.
          To avoid IP fragmentation, it should not exceed the interface MTU value.
          The default value is the interface MTU value, and the value will be clamped to a minimum of
          512 bytes + IP packet overhead.
        '';
      };

      checkLink = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = ''
          If set, the hardware link state (as reported by OS) is taken into consideration. When the link disappears
          (e.g. an ethernet cable is unplugged), neighbors are immediately considered unreachable and all routes
          received from them are withdrawn. It is possible that some hardware drivers or platforms do not implement
          this feature.
          Default: yes.
        '';
      };

      nextHop.ipv4 = mkStrOption ''
        Set the next hop address advertised for IPv4 routes advertised on this interface.
        Default: the preferred IPv4 address of the interface.
      '';

      nextHop.ipv6 = mkStrOption ''
        Set the next hop address advertised for IPv6 routes advertised on this interface.
        If not set, the same link-local address that is used as the source for Babel packets will be used.
        In normal operation, it should not be necessary to set this option.
      '';
    };
  });

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

  deviceProtocolBlock = types.submodule {
    options = {
      scanTime = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      template = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };
  };
  formatDeviceProtocolBlock = device:
    ''
      ${optionalNullString device.scanTime "scan time ${toString device.scanTime};"}
    '';

  directProtocolBlock = types.submodule {
    options = {
      channels = mkOption {
        type = types.loaOf channelBlock;
        default = {};
      };

      interfaces = mkOption {
        type = types.listOf types.str;
        default = [];
      };

      template = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };
  };
  formatDirectProtocol = direct:
  ''
      ${lib.concatStringsSep "\n" (map (interface: ''
        interface "${interface}";
      '') direct.interfaces )}
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: channel: ''
        ${formatChannel channel}
      '') direct.channels)}
  '';


  kernelProtocolBlock = types.submodule ({ name, ...  }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };

      template = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      channels = mkOption {
        type = types.loaOf channelBlock;
        default = {};
      };

      table = mkOption {
        type = types.nullOr types.int;
        default = null;
      };
    };
  });
  formatKernelProtocol = kernel: ''
    ${optionalNullString kernel.table "kernel table ${toString kernel.table};"}
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: channel: ''
      ${formatChannel channel}
    '') kernel.channels)}
  '';

  
  BGPProtocolBlock = types.submodule ({ name, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };

      template = mkOption {
        type = types.nullOr types.str;
        default = null;
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
  formatBGPProtocolBlock = proto:
    ''
        local as ${toString proto.as};
        ${optionalString proto.gracefulRestart "graceful restart on;"}
        ${optionalNullString proto.multihop "multihop ${toString proto.multihop};"}
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: channel: ''
          ${formatChannel channel}
        '') proto.channels)}
        ${optionalNullString proto.source "source address ${proto.source};"}
        ${optionalNullString proto.neighbor.address "neighbor ${proto.neighbor.address} as ${toString proto.neighbor.as};"}
    '';

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
      # templates
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: template: ''
        template bgp ${template.name} ${optionalNullString template.template "from ${template.template}"} {
          ${formatBGPProtocolBlock template}
        }
      '') cfg.templates.bgp)}
      # protocol kernel
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: kernel: ''
        protocol kernel ${name} ${optionalNullString kernel.template "from ${kernel.template}"} {
          ${formatKernelProtocol kernel}
        }
      '') cfg.protocols.kernel)}
      # TODO
      # protocol device
      ${lib.concatStringsSep "\n" (map (device: ''
        protocol device ${optionalNullString device.template "from ${device.template}"} {
          ${formatDeviceProtocolBlock device}
        }
      '') cfg.protocols.device)}
      # protocol direct
      ${lib.concatStringsSep "\n" (map (direct: ''
        protocol direct ${optionalNullString direct.template "from ${direct.template}"} {
          ${formatDirectProtocol direct}
        }
      '') cfg.protocols.direct)}
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
          protocol bgp ${proto.name} ${optionalNullString proto.template "from ${proto.template}"} {
          ${formatBGPProtocolBlock proto}
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

      templates.bgp = mkOption {
        type = types.loaOf BGPProtocolBlock;
        default = {};
      };

      protocols.static = mkOption {
        type = types.loaOf staticProtocolBlock;
        default = {};
      };

      protocols.device = mkOption {
        type = types.listOf deviceProtocolBlock;
        default = [];
      };

      protocols.direct = mkOption {
        type = types.listOf directProtocolBlock;
        default = [];
      };

      protocols.bgp = mkOption {
        type = types.loaOf BGPProtocolBlock;
        default = {};
      };

      protocols.kernel = mkOption {
        type = types.loaOf kernelProtocolBlock;
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
