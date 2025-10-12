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
    programs.hyprland.enable = true;
  };
}
