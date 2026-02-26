{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.hardware.printing;
in
{
  options.modules.system.hardware.printing = {
    enable = mkEnableOption ''
      Enable printing with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    services.printing.enable = true;
  };
}
