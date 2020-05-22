{ pkgs, lib, ... }:

{
  services.pipewire.enable = true;

  hardware.pulseaudio.package = lib.mkDefault pkgs.pulseaudioFull;

  services.jack.jackd.enable = true;
  users.users.kloenk.extraGroups = [ "jackaudio" ];

  environment.systemPackages = with pkgs; [
    jack_oscrolloscope
    jackmeter
    jamin
    patchage
    qjackctl
  ];
}
