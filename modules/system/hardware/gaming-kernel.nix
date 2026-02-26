{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.system.hardware.gamingKernel;
in
{
  options.modules.system.hardware.gamingKernel = {
    enable = mkEnableOption ''
      Enable gaming kernel with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_zen;
  };
}
