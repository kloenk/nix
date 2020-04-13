{ modulesPath, pkgs, lib, ... }:

{
  imports = [
    ../modules
    ../configuration/common
  ];

  networking.useDHCP = false;
  boot.loader.grub.enable = false;
  boot.kernelParams = [
      "panic=30" "boot.panic_on_fail"
  ];
  systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
  networking.hostName = "kexec";
 
  environment.systemPackages = with pkgs; [
    chntpw
    ntfs3g
  ];
 
  system.activationScripts = {
    base-dirs = {
      text = ''
        mkdir -p /nix/var/nix/profiles/per-user/kloenk
      '';
      deps = [];
    };
  };
}

/*{ nixpkgs, home-manager, system ? builtins.currenSystem, ...}:

let 
  nixos = import (nixpkgs + "/nixos") {
    inherit system;
    configuration = { pkgs, lib, ... }: {
      imports = [
        #../sources/nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix
        #../sources/nixpkgs/nixos/modules/installer/cd-dvd/channel.nix
        ../modules
        (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
        (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
        (home-manager + "/nixos")
        ../configuration/common
      ];
      networking.useDHCP = false;
      boot.loader.grub.enable = false;
      boot.kernelParams = [
          "panic=30" "boot.panic_on_fail"
      ];
      systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
      networking.hostName = "kexec";

      environment.systemPackages = with pkgs; [
        chntpw
        ntfs3g
      ];

      system.activationScripts = {
        base-dirs = {
          text = ''
            mkdir -p /nix/var/nix/profiles/per-user/kloenk
          '';
          deps = [];
        };
      };
    };
  };
in
  nixos.config.system.build.isoImage*/
