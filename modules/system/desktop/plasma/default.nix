{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.system.desktop.plasma;
in
{
  options.modules.system.desktop.plasma = {
    enable = mkEnableOption ''
      Enable plasma with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager = {
      sddm.enable = true;
      defaultSession = "plasma";
    };
    services.desktopManager.plasma6.enable = true;

    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; with kdePackages; [
      krfb # Use by kdeconnect for virtualmonitorplugin "krfb-virtualmonitor"
      discover

      # Usefull for automatic informations collect software like KDE
      vulkan-tools # For vulkaninfo command
      wayland-utils # For wayland-info command
      glxinfo
      clinfo
      aha
    ];
  };
}
