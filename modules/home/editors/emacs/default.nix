{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.home.editors.emacs;
in
{
  options.modules.home.editors.emacs = {
    enable = mkEnableOption ''
      Enable emacs with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d;
    };
  };
}