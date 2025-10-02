{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.home.apps.discord;
in
{
  options.modules.home.apps.discord = {
    enable = mkEnableOption ''
      Enable discord
    '';
  };
  config = mkIf cfg.enable {
    programs.vesktop = {
      enable = true;
    };
  };
}

