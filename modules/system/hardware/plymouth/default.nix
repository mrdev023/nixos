{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.hardware.plymouth;
in
{
  options.modules.system.hardware.plymouth = {
    enable = mkEnableOption ''
      Enable plymouth with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    boot.plymouth.enable = true;
  };
}