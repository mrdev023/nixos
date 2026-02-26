{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.hardware.waydroid;
in
{
  options.modules.system.hardware.waydroid = {
    enable = mkEnableOption ''
      Enable waydroid with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    virtualisation.waydroid.enable = true;
  };
}
