{ lib, pkgs, config, ... }:

{
  
  boot.supportedFilesystems = [ "f2fs" "ext4" "ext2" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vdb"; # change
  boot.extraModulePackages = [
    config.boot.kernelPackages.wireguard
  ];

  # taken from hardware-configuration.nix
  boot.initrd.availableKernelModules = [
   "virtio-pci"  # network in initrd
   "aes_x86_64"
   "aesni_intel"
   "cryptd"
   "ata_piix"
   "uhci_hcd"
   "virtio_pci"
   "sr_mod"
   "virtio_blk"
  ];
  nix.maxJobs = lib.mkDefault 8;

  fileSystems."/" = {
    device = "/dev/mapper/cryptRoot";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/vdb1";
    fsType = "ext2";
  };

  fileSystems."/ssd" = {
    device = "/dev/mapper/cryptData";
    fsType = "f2fs";
  };

  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices."cryptData".device = "/dev/vdb2";
  boot.initrd.luks.devices."cryptRoot".device = "/dev/vda1"; # change

  swapDevices = [ { device = "/dev/vda2"; randomEncryption = { enable = true; source = "/dev/random"; }; } ]; # change

}