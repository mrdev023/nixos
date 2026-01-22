{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.shell.superfile;
in
{
  options.modules.home.shell.superfile = {
    enable = mkEnableOption ''
      Enable superfile with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.superfile = {
      enable = true;

      hotkeys = {
        quit = [ "q" ]; # Remove esc shortcut to avoid quit accidentally
      };

      settings = {
        transparent_background = true;
      };
    };
  };
}
