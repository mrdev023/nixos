{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.home.apps.minecraft;
in
{
  options.modules.home.apps.minecraft = {
    enable = mkEnableOption ''
      Enable minecraft
    '';
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [gdlauncher-carbon];
  };
}