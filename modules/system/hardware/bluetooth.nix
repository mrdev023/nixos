{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.hardware.bluetooth;
in
{
  options.modules.system.hardware.bluetooth = {
    enable = mkEnableOption ''
      Enable pipewire with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
  };
}
