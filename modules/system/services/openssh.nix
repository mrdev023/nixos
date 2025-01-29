{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.services.openssh;
in
{
  options.modules.system.services.openssh = {
    enable = mkEnableOption ''
      Enable openssh with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = true;
      };
    };
  };
}