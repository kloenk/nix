{ pkgs, ... }:

{
  security.hideProcessInformation = false;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  environment.systemPackages = with pkgs;
    [
      gnome3.adwaita-icon-theme # gnome-shell-extension-appindicator-32
    ];

  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  services.gnome3.core-shell.enable = true;
  services.gnome3.core-utilities.enable = true;
  services.gnome3.gnome-settings-daemon.enable = true;
  services.gnome3.gnome-online-accounts.enable = true;
  services.gnome3.chrome-gnome-shell.enable = true;
  services.gnome3.gnome-online-miners.enable = true;
  services.gnome3.core-os-services.enable = true;
  services.gnome3.gnome-keyring.enable = true;
  services.gnome3.tracker.enable = true;
}
