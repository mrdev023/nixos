{ config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  services.xserver.desktopManager.plasma6.enable = true;
}
