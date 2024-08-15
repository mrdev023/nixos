{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.system.server.docker;
in
{
  options.modules.system.server.docker = {
    enable = mkEnableOption ''
      Enable docker with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
    };

    users.users.florian.extraGroups = [ "docker" ];
  };
}