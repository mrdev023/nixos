{ config, lib, ... }:

with lib;
let
  cfg = config.modules.home.shell.lazygit;
in
{
  options.modules.home.shell.lazygit = {
    enable = mkEnableOption ''
      Enable lazygit with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;

      settings = {
        git = {
          paging.externalDiffCommand = "difft --color=always";
          overrideGpg = true;
        };
      };
    };
  };
}
