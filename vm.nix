{ pkgs ? import <nixpkgs> {}, ... }:

let
  mkVM = name: options: (import <nixos/nixos/lib/eval-config.nix> {
    inherit (pkgs) system;
    modules = [
      ({ config, pkgs, ...}: {
        imports = [
          <nixos/nixos/modules/virtualisation/qemu-vm.nix>
          options.configuration
          { system.build.qemu = pkgs.qemu_kvm; }
        ];

        config = {
          security.acme.production = false;
          #services.nginx.*.enableACME = false;
          #services.nginx.*.forceSSL = false;
          virtualisation = {
            inherit (options) memorySize cores diskSize;
#            qemu.networkingOptions = [
#              "-nic tap,model=virtio,vhost=on,script=${ifup},downscript=${ifdown}"
#            ];
          };
        };
      })
    ];
  }).config.system.build.vm;

in 
  #mkVM "vm" {
  #  configuration = ./configuration/hosts/vm.nix;
  #  memorySize = 2048;
  #  cores = 2;
  #  diskSize = 4000;
  #}
  mkVM "vm" {
    configuration = ./configuration/hosts/vm.nix;
    memorySize = 4096;
    cores = 4;
    diskSize = 4000;
  }


