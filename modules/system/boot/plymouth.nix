{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.boot.plymouth;
in
{
  options.modules.system.boot.plymouth = {
    enable = mkEnableOption ''
      Enable plymouth with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    boot.plymouth.enable = true;
  };
}