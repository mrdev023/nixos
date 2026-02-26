{ config, lib, ... }:

with lib;
let
  cfg = config.modules.home.shell.direnv;
in
{
  options.modules.home.shell.direnv = {
    enable = mkEnableOption ''
      Enable direnv with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
    };
  };
}
