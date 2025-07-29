{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.containers.home-assistant;
  cfgContainers = config.services.containers;
in
{
  options.services.containers.home-assistant = {
    enable = mkEnableOption "Home Assistant container service";
  };

  config = mkIf cfg.enable {
  virtualisation.oci-containers.containers = {
    home-assistant = {
      image = "homeassistant/home-assistant";
      autoStart = true;
      volumes = [
        "${cfgContainers.workPath}/home_assistant/base:/config"
        "/etc/localtime:/etc/localtime:ro"
        "/run/dbus:/run/dbus:ro"
      ];
      environment = {
        TZ = "Europe/Paris";
      };
      extraOptions = [
        "--privileged"
        "--network=host"
        "--label=traefik.enable=true"
        "--label=traefik.http.routers.homeassistant-secure.entrypoints=https"
        "--label=traefik.http.routers.homeassistant-secure.rule=Host('domo.${cfgContainers.domain}')"
        "--label=traefik.http.routers.homeassistant-secure.tls=true"
        "--label=traefik.http.routers.homeassistant-secure.tls.certresolver=sslResolver"
        "--label=traefik.http.routers.homeassistant-secure.middlewares=private-network@file"
        "--label=traefik.http.services.homeassistant.loadbalancer.server.port=8123"
      ];
    };
  };

    # Create the necessary directories
    system.activationScripts.home-assistant-dirs = ''
      mkdir -p ${cfgContainers.workPath}/home_assistant/base
    '';

    # Ensure DBus is available for Home Assistant
    services.dbus.enable = true;
  };
}