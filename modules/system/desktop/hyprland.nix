{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.desktop.hyprland;
in
{
  options.modules.system.desktop.hyprland = {
    enable = mkEnableOption ''
      Enable hyprland with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    services.displayManager.sddm.enable = mkDefault true;
    services.displayManager.sddm.wayland.enable = true;
    services.power-profiles-daemon.enable = true;
    programs.hyprland.enable = true;
  };
}
