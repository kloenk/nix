{ config, pkgs, ... }:

{

  fileSystems."/var/lib/hydra" = {
    device = "/persist/data/hydra";
    fsType = "none";
    options = [ "bind" ];
  };

  services.hydra = {
    enable = true;
    package = pkgs.hydra-unstable;
    port = 3015;
    listenHost = "0.0.0.0";
    notificationSender = "hydra@kloenk.de";
    extraConfig = ''
      store_uri = s3://nix?endpoint=144.76.19.168%3A9000&scheme=http
      binary_cache_public_uri = https://cache.kloenk.de

      upload_logs_to_binary_cache = true
    '';

    hydraURL = "hydra.kloenk.de";
    useSubstitutes = true; # nixpkgs is to broken at the moment
  };
  nix.trustedUsers = [ "hydra" ];

  services.nginx.virtualHosts."hydra.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3015";
  };

  nix.buildMachines = [
    {
      hostName = "lycus.yougen.de";
      sshUser = "buildfarm";
      sskKey = config.krops.secrets.files."buildkey".path;
      system = "x86_64-linux";
      maxJobs = 8;
      speedFactor = 1;
      supportedFeatures = [ "kvm" "nixos-test" "benchmark" "big-parallel" ];
    }
    {
      hostName = "localhost";
      system = "x86_64-linux";
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
      maxJobs = config.nix.maxJobs;
    }
  ];
  krops.secrets.files."buildkey".owner = "root";
  programs.ssh.knownHosts.lycus = {
    hostNames = [ "[lycus.yougen.de]:62954" "[10.0.0.5]:62954" ];
    publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOiB0F1JwztcIQHXcJ4/+U1IL/qF9WBAW3P9yeEV+ybd";
  };
  programs.ssh.extraConfig = ''
    Host lycus.yougen.de
      Port 62954
  '';

  services.nix-serve = {
    enable = true;
    secretKeyFile = config.krops.secrets.files."signignkey".path;
  };
  krops.secrets.files."signignkey".owner = "nix-serve";
  users.users.nix-serve.extraGroups = [ "keys" ];

  services.nginx.virtualHosts."cache.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:5000";
  };
}
