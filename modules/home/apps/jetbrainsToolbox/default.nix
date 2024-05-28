{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.home.apps.jetbrainsToolbox;
in
{
  options.modules.home.apps.jetbrainsToolbox = {
    enable = mkEnableOption ''
      Enable jetbrainsToolbox with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [jetbrains-toolbox];
  };
}