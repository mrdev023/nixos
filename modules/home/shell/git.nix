{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.home.shell.git;
in
{
  options.modules.home.shell.git = {
    enable = mkEnableOption ''
      Enable git with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ gitflow ];

    programs.git = {
      enable = true;
      lfs.enable = true;

      signing = {
        signByDefault = true;
        format = "openpgp";
        key = "B19E3F4A2D806AB4793FDF2FC73D37CBED7BFC77";
      };

      settings = {
        user = {
          name = "Florian RICHER";
          email = "florian.richer@protonmail.com";
        };

        pull.rebase = "true";
        url."https://invent.kde.org/".insteadOf = "kde:";
        url."ssh://git@invent.kde.org/".pushInsteadOf = "kde:";
      };
    };
  };
}
