{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.containers.watchtower;
  cfgContainers = config.services.containers;
in
{
  options.services.containers.watchtower = {
    enable = mkEnableOption "Watchtower container service";
  };

  config = mkIf cfg.enable {
  virtualisation.oci-containers.containers = {
    watchtower = {
      image = "containrrr/watchtower:latest";
      autoStart = true;
      volumes = [
        "/run/podman/podman.sock:/var/run/docker.sock"
        "/root/.docker/config.json:/config.json:ro"
      ];
      environment = {
        WATCHTOWER_HTTP_API_TOKEN = "watchtower";
        WATCHTOWER_HTTP_API_METRICS = "true";
        WATCHTOWER_POLL_INTERVAL = "1";
      };
      extraOptions = [
        "--network=watchtower-metrics"
      ];
    };
  };

    # Create networks
    systemd.services.create-watchtower-network = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.podman}/bin/podman network exists watchtower-metrics || \
        ${pkgs.podman}/bin/podman network create watchtower-metrics
      '';
    };
  };
}