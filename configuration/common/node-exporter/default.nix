{ config, pkgs, ... }:

{
  services.prometheus.exporters.node.enable = true;
  services.prometheus.exporters.node.enabledCollectors = [ "logind" "systemd" ];
  services.prometheus.exporters.node.extraFlags = [
    "--collector.textfile.directory=/var/lib/prometheus-node-exporter-text-files"
  ];
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
      allow 195.39.246.48/28;
      allow 2a0f:4ac0:f199::/48;
      allow 192.168.42.0/24;
      allow 127.0.0.0/8;
      allow 195.39.221.187/32;
      allow 2a01:4ac0:42::f144:1/128;
      deny all;
    '';
    locations."/wireguard/".proxyPass = "http://127.0.0.1:9586/";
    locations."/wireguard/".extraConfig =
      config.services.nginx.virtualHosts."${config.networking.hostName}.kloenk.de".locations."/node-exporter/".extraConfig;
    locations."/nginx-exporter/".proxyPass = "http://127.0.0.1:9113/";
    locations."/nginx-exporter/".extraConfig =
      config.services.nginx.virtualHosts."${config.networking.hostName}.kloenk.de".locations."/node-exporter/".extraConfig;
    /* locations."/nixos-exporter/".proxyPass = "http://127.0.0.1:9300/";
       locations."/nixos-exporter/".extraConfig =
         config.services.nginx.virtualHosts."${config.networking.hostName}.kloenk.de".locations."/node-exporter/".extraConfig;
    */
  };

  /* system.activationScripts.node-exporter-system-version = ''
       mkdir -pm 0775 /var/lib/prometheus-node-exporter-text-files
       cd /var/lib/prometheus-node-exporter-text-files
       ${
         config.sources.nixos-org
         + "/modules/prometheus/system-version-exporter.sh"
       } | ${pkgs.moreutils}/bin/sponge system-version.prom
     '';

     systemd.services.prometheus-nixos-exporter = {
       wantedBy = [ "multi-user.target" ];
       after = [ "network.target" ];
       path = [ pkgs.nix pkgs.bash ];
       serviceConfig = {
         Restart = "always";
         RestartSec = "60s";
         ExecStart =
           let python = pkgs.python3.withPackages (p: [ p.prometheus_client ]);
           in ''
             ${python}/bin/python ${
               (config.sources.nixos-org + "/modules/prometheus/nixos-exporter.py")
             }
           '';
       };
     };
  */
}
