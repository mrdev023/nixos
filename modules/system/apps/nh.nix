{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.apps.nh;
in
{
  options.modules.system.apps.nh = {
    enable = mkEnableOption ''
      Enable nh
    '';
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;

      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 3";
      };
    };
  };
}
