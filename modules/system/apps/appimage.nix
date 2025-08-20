{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.apps.appimage;
in
{
  options.modules.system.apps.appimage = {
    enable = mkEnableOption ''
      Enable appimage support
    '';
  };

  config = mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
