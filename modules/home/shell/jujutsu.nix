{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.home.shell.jujutsu;
in
{
  options.modules.home.shell.jujutsu = {
    enable = mkEnableOption ''
      Enable jujutsu with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;

      settings = {
        user = {
          name = "Florian RICHER";
          email = "florian.richer@protonmail.com";
        };

        signing = {
          behavior = "own";
          backend = "gpg";
          key = "B19E3F4A2D806AB4793FDF2FC73D37CBED7BFC77";
        };

        git = {
          sign-on-push = true;
        };

        ui = {
          diff-formatter = ["${lib.getExe pkgs.difftastic}" "--color=always" "$left" "$right"];
        };
      };
    };
  };
}
