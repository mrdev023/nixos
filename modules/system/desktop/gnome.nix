{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.desktop.gnome;
in
{
  options.modules.system.desktop.gnome = {
    enable = mkEnableOption ''
      Enable gnome with my custom configurations
    '';

    enableGdm = mkOption {
      type = types.bool;
      description = "Enable gdm with custom gnome";
      default = true;
    };
  };
  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the Gnome Desktop Environment.
    services.xserver.displayManager.gdm.enable = cfg.enableGdm;

    # Enable the GNOME shell.
    services.xserver.desktopManager.gnome.enable = true;
  };
}