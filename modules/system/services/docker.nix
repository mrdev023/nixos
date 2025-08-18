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

    dataRoot = mkOption {
      type = with lib.types; nullOr str;
      description = "Change the data root of docker daemon";
      default = null;
    };
  };
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;

      daemon.settings = lib.mkMerge [
        (lib.mkIf (cfg.dataRoot != null) { "data-root" = cfg.dataRoot; })
      ];
    };
    virtualisation.oci-containers.backend = "docker";
  };
}
