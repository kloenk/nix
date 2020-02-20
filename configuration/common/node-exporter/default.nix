{ config, ... }:

{
  services.prometheus.exporters.node.enable = true;
  services.prometheus.exporters.node.enabledCollectors = [ "logind" "systemd" ];
  services.prometheus.exporters.nginx.enable = true;
  services.prometheus.exporters.wireguard.enable = true;
  services.prometheus.exporters.wireguard.withRemoteIp = true;
  services.nginx.statusPage = true;
  services.nginx.virtualHosts."${config.networking.hostName}.kloenk.de" = {
    enableACME = true;
    addSSL = true;
    locations."/node-exporter/".proxyPass = "http://127.0.0.1:9100/";
    locations."/node-exporter/".extraConfig = ''
      allow ::1/128;
      allow 51.254.249.187/32;
      allow 195.39.246.48/28;
      allow 2a0f:4ac0:f199::/48;
      allow 192.168.42.0/24;
      allow 127.0.0.0/8;
      deny all;
    '';
    locations."/wireguard/".proxyPass = "http://127.0.0.1:9586/";
    locations."/wireguard/".extraConfig = config.services.nginx.virtualHosts."${config.networking.hostName}.kloenk.de".locations."/node-exporter/".extraConfig;
    locations."/nginx-exporter/".proxyPass = "http://127.0.0.1:9113/";
    locations."/nginx-exporter/".extraConfig = config.services.nginx.virtualHosts."${config.networking.hostName}.kloenk.de".locations."/node-exporter/".extraConfig;
  };
}
