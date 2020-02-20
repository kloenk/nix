{ ... }:

{
    networking.firewall.allowedTCPPorts = [ 53 ];
    networking.firewall.allowedUDPPorts = [ 53 ];

    services.bind.enable = true;
    services.bind.forwarders = [ "8.8.8.8" ];
}