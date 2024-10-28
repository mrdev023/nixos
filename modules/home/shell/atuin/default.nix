{ config, lib, ... }:

with lib;
let
  cfg = config.modules.home.shell.atuin;
in
{
  options.modules.home.shell.atuin = {
    enable = mkEnableOption ''
      Enable atuin with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      settings = {
        # Uncomment this to use your instance
        # sync_address = "https://majiy00-shell.fly.dev";
      };
    };
  };
}