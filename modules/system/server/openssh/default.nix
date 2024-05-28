{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.system.server.openssh;
in
{
  options.modules.system.server.openssh = {
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