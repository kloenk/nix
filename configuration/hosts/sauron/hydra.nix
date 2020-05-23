{ config, pkgs, ... }:

{

  fileSystems."/var/lib/hydra" = {
    device = "/persist/data/hydra";
    fsType = "none";
    options = [ "bind" ];
  };

  services.hydra = {
    enable = true;
    package = pkgs.hydra-patched;
    port = 3015;
    listenHost = "0.0.0.0";
    notificationSender = "hydra@kloenk.de";
    extraConfig = ''
      allow-import-from-derivation = true
    '';

    hydraURL = "hydra.kloenk.de";
  };
  nix.trustedUsers = [ "hydra" ];

  services.nginx.virtualHosts."hydra.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3015";
  };

  nix.extraOptions = ''
    allow-import-from-derivation = true
  '';

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
