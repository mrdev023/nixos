{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.apps.scrcpy;
in
{
  options.modules.home.apps.scrcpy = {
    enable = mkEnableOption ''
      Enable scrcpy with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      scrcpy
      qtscrcpy
    ];
  };
}
