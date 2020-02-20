{ lib, config, ... }:

let
  fwcfg = config.networking.firewall;
  cfg = config.services.ferm2;

in {
  options = with lib; {
    services.ferm2 = {
      enable = mkEnableOption "Ferm easy rule making";
      extraConfig = mkOption {
        type = types.lines;
        default = "";
      };
      extraConfig6 = mkOption {
        type = types.lines;
        default = "";
      };
      extraConfig4 = mkOption {
        type = types.lines;
        default = "";
      };
      extraInput = mkOption {
        type = types.lines;
        default = "";
      };
      extraInput6 = mkOption {
        type = types.lines;
        default = "";
      };
      extraInput4 = mkOption {
        type = types.lines;
        default = "";
      };
      extraOutput = mkOption {
        type = types.lines;
        default = "";
      };
      extraOutput6 = mkOption {
        type = types.lines;
        default = "";
      };
      extraOutput4 = mkOption {
        type = types.lines;
        default = "";
      };
      extraForward = mkOption {
        type = types.lines;
        default = "";
      };
      extraForward6 = mkOption {
        type = types.lines;
        default = "";
      };
      extraForward4 = mkOption {
        type = types.lines;
        default = "";
      };
      inputPolicy = mkOption {
        type = types.str;
        default = "DROP";
      };
      outputPolicy = mkOption {
        type = types.str;
        default = "ACCEPT";
      };
      forwardPolicy = mkOption {
        type = types.str;
        default = "ACCEPT";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.enable = false;
    services.ferm.enable = true;
    services.ferm.config = ''
      domain ip6 {
        table filter {
          chain INPUT {
            policy ${cfg.inputPolicy};

            proto ipv6-icmp icmpv6-type redirect DROP;
            proto ipv6-icmp icmpv6-type 139 DROP;
            proto ipv6-icmp ACCEPT;

            mod state state INVALID DROP;
            mod state state (ESTABLISHED RELATED) ACCEPT;

            interface (lo ${lib.concatStringsSep " " fwcfg.trustedInterfaces}) ACCEPT;

            proto tcp dport (${lib.concatStringsSep " " (map toString fwcfg.allowedTCPPorts)}) ACCEPT;
            proto udp dport (${lib.concatStringsSep " " (map toString fwcfg.allowedUDPPorts)}) ACCEPT;

            proto udp dport 546 daddr fe80::/64 ACCEPT;

            ${cfg.extraInput}
            ${cfg.extraInput6}
          }
          chain OUTPUT {
            policy ${cfg.outputPolicy};

            ${cfg.extraOutput}
            ${cfg.extraOutput6}
          }
          chain FORWARD {
            policy ${cfg.forwardPolicy};

            ${cfg.extraForward}
            ${cfg.extraForward6}
          }
        }

        ${cfg.extraConfig}
        ${cfg.extraConfig6}
      }

      domain ip {
        table filter {
          chain INPUT {
            policy ${cfg.inputPolicy};

            proto icmp icmp-type echo-request ACCEPT;

            mod state state INVALID DROP;
            mod state state (ESTABLISHED RELATED) ACCEPT;

            interface (lo ${lib.concatStringsSep " " fwcfg.trustedInterfaces}) ACCEPT;

            proto tcp dport (${lib.concatStringsSep " " (map toString fwcfg.allowedTCPPorts)}) ACCEPT;
            proto udp dport (${lib.concatStringsSep " " (map toString fwcfg.allowedUDPPorts)}) ACCEPT;

            ${cfg.extraInput}
            ${cfg.extraInput4}
          }
          chain OUTPUT {
            policy ${cfg.outputPolicy};

            ${cfg.extraOutput}
            ${cfg.extraOutput4}
          }
          chain FORWARD {
            policy ${cfg.forwardPolicy};

            ${cfg.extraForward}
            ${cfg.extraForward4}
          }
        }

        ${cfg.extraConfig}
        ${cfg.extraConfig4}
      }
    '';
  };
}
