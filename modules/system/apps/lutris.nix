{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.system.apps.lutris;

  lutris = pkgs.lutris.override {
    extraLibraries =
      pkgs: with pkgs; [
        # For Unreal Engine Fab Plugin
        nspr
        libxdamage
      ];
  };
in
{
  options.modules.system.apps.lutris = {
    enable = mkEnableOption ''
      Enable lutris
    '';
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ lutris ];
  };
}
