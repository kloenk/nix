let
  nixos = import ../sources/nixpkgs/nixos {
    configuration = { lib, pkgs, ... }: {
      imports = [
        ../sources/nixpkgs/nixos/modules/installer/netboot/netboot-minimal.nix
        ./kexec.nix
        ../configuration/common
      ];
      boot.loader.grub.enable = false;
      boot.kernelParams = [
        "panic=30" "boot.panic_on_fail" # reboot the machine upon fatal boot issues
      ];
      systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
      networking.hostName = "kexec";
      networking.useNetworkd = false;

      boot.postBootCommands = let
        nixpkgs = pkgs.lib.cleanSource pkgs.path;
        channelSources = pkgs.runCommand "nixpkgs" { preferLocalBuild = true; } ''
          cp -prd ${nixpkgs.outPath} $out
          chmod -R u+w $out
        '';

      in lib.mkAfter ''
        echo "unpacking the NixOS/Nixpkgs sources..."
        mkdir -p /var/src
        cp -r ${channelSources} /var/src/nixpkgs
      '';
    };
  };

in nixos.config.system.build.kexec_tarball
