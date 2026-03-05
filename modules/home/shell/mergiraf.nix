{ config, lib, ... }:

with lib;
let
  cfg = config.modules.home.shell.mergiraf;
in
{
  options.modules.home.shell.mergiraf = {
    enable = mkEnableOption ''
      Enable mergiraf with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    # Already configure git and jujutsu to use mergiraf
    programs.mergiraf.enable = true;
  };
}
