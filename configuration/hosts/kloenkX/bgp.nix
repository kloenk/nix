{ config, lib, ... }:

let
  cfg = config.services.bgp;
  hosts = import ../.;
  thisHost = hosts.${config.networking.hostName};
  as = "65249";
  bgpHosts = lib.filterAttrs (name: host: host ? bgp && host ? wireguard && name != config.networking.hostName) hosts;
  primaryIP = "2a0f:4ac0:f199::6";
  primaryIP4 = "195.39.246.50";

in {
  networking.firewall.allowedUDPPorts = lib.mapAttrsToList (name: host: 51820 + host.magicNumber + thisHost.magicNumber) bgpHosts;
  
  systemd.network.netdevs = (lib.mapAttrs' (name: host:      let
    port = 51820 + host.magicNumber + thisHost.magicNumber;      in lib.nameValuePair "30-wg-${name}" {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg-${name}";
    };
    netdevConfig = {
      MTUBytes = "1402";
    };
    wireguardConfig = {
      FwMark = 51820;
      ListenPort = port;
      PrivateKeyFile = config.krops.secrets.files."wg-pbb.key".path;
    };
    wireguardPeers = [
      {
        wireguardPeerConfig = {
          AllowedIPs = [ "::/0" "0.0.0.0/0" ];
          PublicKey = host.wireguard.publicKey;
        }
          //
        (
          if host.wireguard ? endpoint then
            { Endpoint = lib.optionalAttrs (host.wireguard ? endpoint) "${host.wireguard.endpoint}:${toString port}"; }
          else
            {}
        );
      }
    ];
  }) bgpHosts);

  systemd.network.networks = (lib.mapAttrs' (name: host: lib.nameValuePair "30-wg-${name}" {
    name = "wg-${name}";
    addresses = [
      { addressConfig.Address = "10.23.42.${toString thisHost.magicNumber}/32"; }
      { addressConfig.Address = "fda0::${toString thisHost.magicNumber}/128"; }
      { addressConfig.Address = "fe80::${toString thisHost.magicNumber}/64"; }
    ];
    extraConfig = ''
      [RoutingPolicyRule]
      FirewallMark = 51820
      InvertRule = true
      Table = ${as}
      Family = both
      Priority = 30000
    '';
  }) bgpHosts);

  krops.secrets.files."wg-pbb.key".owner = "systemd-network";
  users.users.systemd-network.extraGroups = [ "keys" ];

  networking.firewall.allowedTCPPorts = [ 179 ];
  users.users.kloenk.extraGroups = [ "bird2" ];

  services.bird2.enable = true;
  services.bird2.config = ''
    router id ${primaryIP4};

    function net_local() {
      if net.type = NET_IP4 then return net ~ [
        195.39.246.48/28+
      ];
      return net ~ [
        2a0f:4ac0:f199::/48+
      ];
    }
    function net_default() {
      if net.type = NET_IP4 then return net ~ [
       0.0.0.0/0
      ];
      return net ~ [
        ::/0
      ];
    } 
    function net_bogon() {
      if net.type = NET_IP4 then return net ~ [
        0.0.0.0/8+,         # RFC 1122 'this' network
        10.0.0.0/8+,        # RFC 1918 private space
        100.64.0.0/10+,     # RFC 6598 Carrier grade nat space
        127.0.0.0/8+,       # RFC 1122 localhost
        169.254.0.0/16+,    # RFC 3927 link local
        172.16.0.0/12+,     # RFC 1918 private space
        192.0.2.0/24+,      # RFC 5737 TEST-NET-1
        192.88.99.0/24+,    # RFC 7526 6to4 anycast relay
        192.168.0.0/16+,    # RFC 1918 private space
        198.18.0.0/15+,     # RFC 2544 benchmarking
        198.51.100.0/24+,   # RFC 5737 TEST-NET-2
        203.0.113.0/24+,    # RFC 5737 TEST-NET-3
        224.0.0.0/4+,       # multicast
        240.0.0.0/4+        # reserved
      ];
      return net ~ [
        ::/8+,                         # RFC 4291 IPv4-compatible, loopback, et al
        0100::/64+,                    # RFC 6666 Discard-Only
        2001:2::/48+,                  # RFC 5180 BMWG
        2001:10::/28+,                 # RFC 4843 ORCHID
        2001:db8::/32+,                # RFC 3849 documentation
        2002::/16+,                    # RFC 7526 6to4 anycast relay
        3ffe::/16+,                    # RFC 3701 old 6bone
        fc00::/7+,                     # RFC 4193 unique local unicast
        fe80::/10+,                    # RFC 4291 link local unicast
        fec0::/10+,                    # RFC 3879 old site local unicast
        ff00::/8+                      # RFC 4291 multicast
      ];
    }
    function as_bogon() {
      return bgp_path ~ [
        0,                      # RFC 7607
        23456,                  # RFC 4893 AS_TRANS
        64496..64511,           # RFC 5398 and documentation/example ASNs
        #64512..65534,           # RFC 6996 Private ASNs
        65535,                  # RFC 7300 Last 16 bit ASN
        65536..65551,           # RFC 5398 and documentation/example ASNs
        65552..131071,          # RFC IANA reserved ASNs
        4200000000..4294967294, # RFC 6996 Private ASNs
        4294967295              # RFC 7300 Last 32 bit ASN
      ];
    }
    protocol kernel {
      kernel table ${as};
      ipv6 {
        import all;
        export filter {
          krt_prefsrc = ${primaryIP};
          accept;
        };
      };
    }
    protocol kernel {
      kernel table ${as};
      ipv4 {
        import all;
        export filter {
          krt_prefsrc = ${primaryIP4};
          accept;
        };
      };
    }
    protocol device {
      scan time 10;
    }
    protocol direct {
      interface "wg-*";
      interface "lo";
      ipv6 { import all; };
      ipv4 { import all; };
    }
  '' + lib.concatStringsSep "\n" (lib.mapAttrsToList (name: host: ''
    protocol static static_tunnel_${name} {
      ipv6 { import all; };
      route fda0::${toString host.magicNumber}/128 via "wg-${name}";
    }
    protocol static static_tunnel_${name}4 {
      ipv4 { import all; };
      route 10.23.42.${toString host.magicNumber}/32 via "wg-${name}";
    }
    protocol bgp ${name} {
      local as ${as};
      graceful restart on;
      multihop 64;
      ipv6 {
        next hop self;
        import keep filtered;
        import filter {
          if net_local() then reject;
          if net_bogon() then reject;
          if as_bogon() then reject;
          if (65535, 0) ~ bgp_community then {
            bgp_local_pref = 0;
          }
          if net_default() then accept;
          reject;
        };
        export filter {
          if !net_local() then reject;
          if net_bogon() then reject;
          if as_bogon() then reject;
          accept;
        };
      };
      source address fda0::${toString thisHost.magicNumber};
      neighbor fda0::${toString host.magicNumber} as ${if host.bgp ? as then host.bgp.as else toString (65000 + host.magicNumber)};
    }
    protocol bgp ${name}4 {
      ${lib.optionalString (host.bgp ? internal) ''
        local as ${toString (65000 + thisHost.magicNumber)};
        confederation ${as};
        confederation member yes;
      ''}
      ${lib.optionalString (!(host.bgp ? internal)) ''
        local as ${as};
      ''}
      graceful restart on;
      multihop 64;
      ipv4 {
        next hop self;
        import keep filtered;
        import filter {
          if net_local() then reject;
          if net_bogon() then reject;
          if as_bogon() then reject;
          if (65535, 0) ~ bgp_community then {
            bgp_local_pref = 0;
          }
          if net_default() then accept;
          reject;
        };
        export filter {
          if !net_local() then reject;
          if net_bogon() then reject;
          if as_bogon() then reject;
          accept;
        };
      };
      source address 10.23.42.${toString thisHost.magicNumber};
      neighbor 10.23.42.${toString host.magicNumber} as ${if host.bgp ? as then host.bgp.as else toString (65000 + host.magicNumber)};
    }
  '') bgpHosts);
} 
