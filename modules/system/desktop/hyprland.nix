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
    services.displayManager.sddm = {
      enable = mkDefault true;
      wayland = {
        enable = true;
        # weston 15 crashes on RDNA4 (gfx1201) due to duplicate DRM modifiers
        compositor = "kwin";
      };
    };
    services.power-profiles-daemon.enable = true;
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
}
