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

      difftastic = {
        enable = true;
        enableAsDifftool = true;
      };

      userName = "Florian RICHER";
      userEmail = "florian.richer@protonmail.com";

      signing = {
        signByDefault = true;
        format = "openpgp";
        key = "B19E3F4A2D806AB4793FDF2FC73D37CBED7BFC77";
      };

      extraConfig = {
        url."https://invent.kde.org/".insteadOf = "kde:";
        url."ssh://git@invent.kde.org/".pushInsteadOf = "kde:";
      };
    };
  };
}
