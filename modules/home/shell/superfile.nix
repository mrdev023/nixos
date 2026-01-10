{ config, pkgs, lib, ... }:

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
    home.packages = with pkgs; [ superfile ];
  };
}
