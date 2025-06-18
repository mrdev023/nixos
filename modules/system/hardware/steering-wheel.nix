{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.hardware.steering-wheel;
in
{
  options.modules.system.hardware.steering-wheel = {
    enable = mkEnableOption ''
      Enable steering wheel with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    boot = {
        blacklistedKernelModules = [ "hid-thrustmaster" ];
        kernelModules = [ "hid-tmff2" ];
        extraModulePackages = [ config.boot.kernelPackages.hid-tmff2 ];
    };
  };
}