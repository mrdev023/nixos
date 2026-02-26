{ config, lib, ... }:

with lib;
let
  cfg = config.services.containers.watchtower;
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
          "/var/run/docker.sock:/var/run/docker.sock"
          "/root/.docker/config.json:/config.json:ro"
        ];
        environment = {
          WATCHTOWER_HTTP_API_TOKEN = "watchtower";
          WATCHTOWER_HTTP_API_METRICS = "true";
          WATCHTOWER_POLL_INTERVAL = "1";
        };
        extraOptions = [
          "--network=metrics"
        ];
      };
    };

    systemd.services.docker-watchtower = {
      after = [
        "create-metrics-network.service"
        "docker.service"
        "docker.socket"
      ];
      requires = [
        "create-metrics-network.service"
        "docker.service"
        "docker.socket"
      ];
    };
  };
}
