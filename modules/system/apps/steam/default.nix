{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.system.apps.steam;
in
{
  options.modules.system.apps.steam = {
    enable = mkEnableOption ''
      Enable steam with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [ gamescope ];
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    hardware.steam-hardware.enable = true;
  };
}
