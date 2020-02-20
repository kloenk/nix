{ config, pkgs, ... }:

let
  secrets = import <secrets/grafana.nix>;
in {
    services.prometheus = {
        enable = true;
        
        globalConfig.scrape_interval = "10s";

        exporters = {
            node.enable = true;
            #node.enabledCollectors = [ "systemd" ];

            postfix.enable = true;
            postfix.systemd.enable = true;

            postgres.enable = true;

            rspamd.enable = true;

            wireguard.enable = true;

            bind.enable = true;

            dovecot.enable = true;

            #nginx.enable = true;
        };

        scrapeConfigs = [
            {
                job_name = "grafana";
                static_configs = [ { targets = [
                  "127.0.0.1:3002"
                ] ; } ];
            }
            {
                job_name = "prometheus";
                static_configs = [ { targets = [
                  "127.0.0.1:9090"
                ] ; } ];
            }
            {
                job_name = "collectd";
                static_configs = [ { targets = [
                    "127.0.0.1:9103" 
                ] ; } ];
            }
            {
                job_name = "exporter-node";
                static_configs = [ { targets = [
                    "127.0.0.1:9100"
                    "kloenkX.kloenk.de:9100"
                    "titan.kloenk.de:9100"
                    "atom.kloenk.de:9100"
                    #"io.kloenk.de:9100"
                ]; } ];
            }
            {
                job_name = "exporter-postfix";
                static_configs = [ { targets = [
                    "127.0.0.1:9154"
                ]; } ];
            }
            {
                job_name = "exporter-postgres";
                static_configs = [ { targets = [
                    "127.0.0.1:9187"
                ]; } ];
            }
            {
                job_name = "exporter-rspamd";
                static_configs = [ { targets = [
                    "127.0.0.1:7980"
                ]; } ];
            }
            {
                job_name = "exporter-wireguard";
                static_configs = [ { targets = [
                    "127.0.0.1:9586"
                ]; } ];
            }
            {
                job_name = "exporter-bind";
                static_configs = [ { targets = [
                    "127.0.0.1:9119"
                ]; } ];
            }
            {
                job_name = "exporter-dovecot";
                static_configs = [ { targets = [
                    "127.0.0.1:9166"
                ]; } ];
            }
            {
                job_name = "exporter-nginx";
                static_configs = [ { targets = [
                    "127.0.0.1:9113"
                ]; } ];
            }
            {
                job_name = "exporter-fritzbox";
                static_configs = [ { targets = [
                    "192.168.42.7:9133"
                ]; } ];
            }
        ];
    };

    services.grafana = {
        enable = true;

        port = 3002;

        analytics.reporting.enable = false;
        rootUrl = "https://grafana.kloenk.de/";
        security.secretKey = secrets.signingKey;
        security.adminUser = "kloenk";
        security.adminPassword = secrets.adminPassword;

        database = {
            type = "postgres";
            host = "127.0.0.1:5432";
            user = "grafana";
            password = "foobar";
        };

        smtp = {
            enable = true;
            fromAddress = "grafana@kloenk.de";
            user = "grafana@kloenk.de";
            passwordFile = toString <secrets/grafana.mail>;
        };
    };

    systemd.services.grafana.after = [ "postgresql.service" ];

    services.nginx.virtualHosts."grafana.kloenk.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:3002";
    };

    services.nginx.virtualHosts."localhost" = {
        enableACME = false;
        forceSSL = false;
        listen = [ { addr = "127.0.0.1"; port = 9113; } ];
        locations."/nginx_status".extraConfig = ''
          stub_status on;
          allow 127.0.0.1;
          deny all;
        '';
    };

    services.collectd2.plugins.nginx.options.URL = "http://localhost:9113/nginx_status";
}
