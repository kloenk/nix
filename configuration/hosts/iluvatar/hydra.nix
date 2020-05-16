{ pkgs, ... }:

{
  services.hydra = {
    enable = true;
    package = pkgs.hydra-unstable;
    port = 315;
    listenHost = "0.0.0.0";
    notificationSender = "hydra@kloenk.de";
  };

  services.nginx.virtualHosts."hydra.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3015";
  };

  nix.buildMachines = [{
    hostName = "lycus.yougen.de";
    sshUser = "buildfarm";
    sskKey = config.krops.secrets.files."buildkey".path;
    system = "x86_64-linux";
    maxJobs = 8;
    speedFactor = 2;
    supportedFeatures = [ "kvm" "nixos-test" "benchmark" "big-parallel" ];
  }];
  krops.secrets.files."buildkey".owner = "root";
}
