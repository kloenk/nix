{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ spectacle firefox riot-desktop ];

  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.xkbVariant = "neo";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
}
