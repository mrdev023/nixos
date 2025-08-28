{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.containers.traefik;
  cfgContainers = config.services.containers;

  traefikStatic = pkgs.writers.writeTOML "traefik.toml" {
    api.dashboard = true;
    log.level = "INFO";
    accessLog = {};
    entryPoints.http.address = ":80";
    entryPoints.https.address = ":443";
    providers.docker = {
      endpoint = "unix:///var/run/docker.sock";
      exposedByDefault = false;
    };
    providers.file = {
      filename = "/dynamic_conf.toml";
      watch = true;
    };
  };

  traefikDynamic = pkgs.writers.writeTOML "dynamic_conf.toml" {
    http.middlewares."private-network".ipWhiteList.sourceRange = [
      "0.0.0.0/0"
      "::/0"
    ];
  };
in
{
  options.services.containers.traefik = {
    enable = mkEnableOption "Traefik reverse proxy container";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.traefik = {
      image = "traefik:latest";
      autoStart = true;
      cmd = [ "--configFile=/traefik.toml" ];
      ports = [
        "80:80"
        "443:443"
      ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
        "${traefikStatic}:/traefik.toml:ro"
        "${traefikDynamic}:/dynamic_conf.toml:ro"
        "${cfgContainers.workPath}/traefik/base/acme.json:/acme.json:rw"
        "/etc/timezone:/etc/timezone:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        TZ = "Europe/Paris";
      };
      extraOptions = [
        "--network=proxy"
        "--add-host=host.docker.internal:host-gateway"
        "--label=traefik.enable=true"
        "--label=traefik.http.routers.api.rule=PathPrefix(`/api`) || PathPrefix(`/dashboard`)"
        "--label=traefik.http.routers.api.entrypoints=http"
        "--label=traefik.http.routers.api.service=api@internal"
      ];
    };

    systemd.services."docker-traefik" = {
      after = [ "create-proxy-network.service" "docker.service" "docker.socket" ];
      requires = [ "create-proxy-network.service" "docker.service" "docker.socket" ];
    };
  };
}


