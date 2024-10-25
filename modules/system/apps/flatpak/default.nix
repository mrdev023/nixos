{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.apps.flatpak;
in
{
  options.modules.system.apps.flatpak = {
    enable = mkEnableOption ''
      Enable flatpak
    '';
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true; # Important can't be enabled from home-manager
  };
}