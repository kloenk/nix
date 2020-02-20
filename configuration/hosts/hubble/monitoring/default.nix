{ lib, config, pkgs, ... }:

let
  hosts = import ../..;

in {
  services.nginx.virtualHosts."grafana.kloenk.de" = {
    locations."/".proxyPass = "http://127.0.0.1:3001/";
    enableACME = true;
    forceSSL = true;
  };
  services.nginx.virtualHosts."prometheus.kloenk.de" = {
    locations."/".proxyPass = "http://127.0.0.1:9090/";
    extraConfig = config.services.nginx.virtualHosts."${config.networking.hostName}.kloenk.de".locations."/node-exporter/".extraConfig;
    enableACME = true;
    forceSSL = true;
  };
  services.nginx.virtualHosts."alertmanager.kloenk.de" = {
    locations."/".proxyPass = "http://127.0.0.1:9093/";
    extraConfig = config.services.nginx.virtualHosts."${config.networking.hostName}.kloenk.de".locations."/node-exporter/".extraConfig;
    enableACME = true;
    forceSSL = true;
  };

  services.prometheus.alertmanager = {
    enable = true;
    webExternalUrl = "https://alertmanager.kloenk.de/";
    listenAddress = "127.0.0.1";
    extraFlags = [
      "--cluster.listen-address="
    ];
    configuration = {
      global = {
        smtp_from = "alertmanager@kloenk.de";
        smtp_smarthost = "kloenk.de:587";
        smtp_auth_username = "alertmanager@kloenk.de";
        smtp_auth_password = lib.fileContents <secrets/alertmanager/mail>; #FIXME: don't copy to nix store #FIXME2: make random password every time
      };
      route = {
        group_by = [ "alertname" "cluster" "service" ];
        group_wait = "30s";
        group_interval = "5m";
        repeat_interval = "6h";
        receiver = "warning";
        routes = [
          {
            match = {
              severity = "critical";
            };
            receiver = "critical";
          }
        ];
      };
      inhibit_rules = [
        {
          source_match = {
            severity = "critical";
          };
          target_match = {
            severity = "warning";
          };
          equal = [ "alertname" "cluster" "service" ];
        }
      ];
      receivers = [
        {
          name = "warning";
          email_configs = [ {
            to = "me@kloenk.de";
          } ];
        }
        {
          name = "critical";
          email_configs = [ {
            to = "me@kloenk.de";
          } ];
        }
      ];
    };
  };
  
  services.grafana = {
    enable = true;
    auth.anonymous.enable = true;
    domain = "grafana.kloenk.de";
    port = 3001;
    rootUrl = "https://grafana.kloenk.de/";
    provision = {
      enable = true;
      datasources = [
        {
          type = "prometheus";
          name = "Prometheus";
          url = "http://127.0.0.1:9090/";
          isDefault = true;
        }
      ];
      dashboards = [
        {
          options.path = ./dashboards;
        }
      ];
    };
  };

  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "10s";
    webExternalUrl = "https://prometheus.kloenk.de/";

    scrapeConfigs = let
      filteredHosts = lib.filterAttrs (name: host: host ? prometheusExporters) hosts;
      makeTargets = name: host: map (exporter: {
        targets = [
          "${name}.kloenk.de"
        ];
        labels = {
          job = name;
          __metrics_path__ = "/${exporter}/metrics";
        };
      }) host.prometheusExporters;
      targets = lib.concatLists (lib.mapAttrsToList makeTargets filteredHosts);
      targetsFile = pkgs.writeText "targets.json" (builtins.toJSON targets);
    in [{
      job_name = "dummy";
      file_sd_configs = [{
        files = [ (toString targetsFile) ];
      }];
    }];

    alertmanagers = [ {
      scheme = "http";
      static_configs = [{
        targets = [
          "127.0.0.1:9093"
        ];
      }];
    }];
    rules = map (r: builtins.toJSON r) [
      {
        groups = [{
          name = "infra";
          rules = [
            {
              alert = "InstanceDown";
              expr = "min(up) by (job) == 0";
              for = "5m";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "{{ $labels.job }} down";
                description = "{{ $labels.job }} has been down for more than 5 minutes.";
              };
            }
            {
              alert = "InstanceDown";
              expr = "min(up) by (job) == 0";
              for = "10m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "{{ $labels.job }} down";
                description = "{{ $labels.job }} has been down for more than 10 minutes.";
              };
            }
            {
              alert = "HighLoad";
              expr = "max(node_load5) by (job) > count(node_cpu_seconds_total{mode=\"system\"}) by (job)";
              for = "1m";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "High system load";
                description = "{{ $labels.job }} has a high system load (current value: {{ $value }})";
              };
            }
            {
              alert = "HighLoad";
              expr = "max(node_load5) by (job) > 2 * count(node_cpu_seconds_total{mode=\"system\"}) by (job)";
              for = "1m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "High system load";
                description = "{{ $labels.job }} has a very high system load (current value: {{ $value }})";
              };
            }
            {
              alert = "LowMemory";
              expr = "((node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes) > 0.75";
              for = "1m";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "Low system memory";
                description = "{{ $labels.job }} is low on system memory (current value: {{ $value }})";
              };
            }
            {
              alert = "LowMemory";
              expr = "((node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes) > 0.9";
              for = "1m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "Low system memory";
                description = "{{ $labels.job }} is very low on system memory (current value: {{ $value }})";
              };
            }
          ];
        }];
      }
    ];
  };
}
