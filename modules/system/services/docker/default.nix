{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.services.docker;
in
{
  options.modules.system.services.docker = {
    enable = mkEnableOption ''
      Enable docker with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
    };
    virtualisation.oci-containers.backend = "docker";

    users.users.florian.extraGroups = [ "docker" ];
  };
}