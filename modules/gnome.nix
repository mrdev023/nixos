{ config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Gnome Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;

  # Enable the GNOME shell.
  services.xserver.desktopManager.gnome.enable = true;
}
