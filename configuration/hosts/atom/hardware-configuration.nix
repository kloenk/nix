{ lib, config, ... }:

{
  hardware.cpu.intel.updateMicrocode = true;

  fileSystems."/" = {
    device = "/dev/disk/by-id/ata-HTS721010G9SA00_MPDZN7Y0J7WN6L-part1";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-id/ata-HTS721010G9SA00_MPDZN7Y0J7WN6L-part2"; } ];

  boot.supportedFilesystems = [ "f2fs" "ext4" "nfs" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-HTS721010G9SA00_MPDZN7Y0J7WN6L";
  #boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.wireguard
  ];

  # taken from hardware-configuration.nix
  boot.initrd.availableKernelModules = [
   "uhci_hcd"
   "ehci_pci"
   "ahci"
   "usbhid"
   "uas"
   "usb_storage"
   "sd_mod"
  ];
  nix.maxJobs = lib.mkDefault 4;
}