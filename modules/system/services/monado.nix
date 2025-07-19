{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.services.monado;
in
{
  options.modules.system.services.monado = {
    enable = mkEnableOption ''
      Enable monado with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    # https://github.com/NixOS/nixpkgs/issues/258196
    services.monado = {
      enable = true;
      defaultRuntime = true;
      forceDefaultRuntime = true;
    };
    
    systemd.user.services.monado.environment = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
    };

    environment.variables = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
      WMR_HANDTRACKING = "0";
    };
  };
}