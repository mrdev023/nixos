{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.system.desktop.gnome;
in
{
  options.modules.system.desktop.gnome = {
    enable = mkEnableOption ''
      Enable gnome with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the Gnome Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;

    # Enable the GNOME shell.
    services.xserver.desktopManager.gnome.enable = true;
  };
}