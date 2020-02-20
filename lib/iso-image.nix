let 
  nixos = import ../sources/nixpkgs/nixos {
      configuration = { lib, ... }: {
          imports = [
              ../sources/nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix
              ../sources/nixpkgs/nixos/modules/installer/cd-dvd/channel.nix
              ../configuration/common
          ];
          networking.useDHCP = false;
          boot.loader.grub.enable = false;
          boot.kernelParams = [
              "panic=30" "boot.panic_on_fail"
          ];
          systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
          networking.hostName = "kexec";

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
  nixos.config.system.build.isoImage
