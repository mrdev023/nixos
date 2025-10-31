{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.home.shell.difftastic;
in
{
  options.modules.home.shell.difftastic = {
    enable = mkEnableOption ''
      Enable difftastic with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.difftastic = {
      enable = true;

      git = {
        enable = true;
        diffToolMode = true;
      };
    };

    programs.jujutsu.settings.ui.diff-formatter = [
      "${lib.getExe pkgs.difftastic}" "--color=always" "$left" "$right"
    ];
  };
}
