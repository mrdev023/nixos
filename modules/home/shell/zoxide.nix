{ config, lib, ... }:

with lib;
let
  cfg = config.modules.home.shell.zoxide;
in
{
  options.modules.home.shell.zoxide = {
    enable = mkEnableOption ''
      Enable zoxide with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
    };
  };
}
