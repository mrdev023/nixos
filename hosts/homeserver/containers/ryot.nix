{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.containers.ryot;
  cfgContainers = config.services.containers;
in
{
  options.services.containers.ryot = {
    enable = mkEnableOption "Ryot container service";
  };

  config = mkIf cfg.enable {
    systemd.services.create-ryot-network = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.lib.getExe pkgs.docker} network inspect ryot-internal >/dev/null 2>&1 || \
        ${pkgs.lib.getExe pkgs.docker} network create ryot-internal
      '';
    };

    virtualisation.oci-containers.containers = {
      ryot_db = {
        image = "postgres:16-alpine";
        autoStart = true;
        volumes = [
          "${cfgContainers.workPath}/ryot/db:/var/lib/postgresql/data"
        ];
        environment = {
          POSTGRES_DB = "postgres";
          POSTGRES_USER = "postgres"; 
          POSTGRES_PASSWORD = "postgres";
        };
        extraOptions = [
          "--network=ryot-internal"
        ];
      };

      ryot = {
        image = "ghcr.io/ignisda/ryot:v9";
        autoStart = true;
        environment = {
          DATABASE_URL = "postgres://postgres:postgres@ryot_db:5432/postgres";
        };
        dependsOn = [
          "ryot_db"
        ];
        extraOptions = [
          "--network=ryot-internal"
          "--network=proxy"
          "--label=traefik.enable=true"
          "--label=traefik.http.routers.ryot-secure.entrypoints=https"
          "--label=traefik.http.routers.ryot-secure.rule=Host(`ryot.${cfgContainers.domain}`)"
          "--label=traefik.http.routers.ryot-secure.tls=true"
          "--label=traefik.http.routers.ryot-secure.tls.certresolver=sslResolver"
          "--label=traefik.http.routers.ryot-secure.middlewares=private-network@file"
          "--label=traefik.http.services.ryot.loadbalancer.server.port=8000"
          "--label=traefik.docker.network=proxy"
        ];
      };
    };

    systemd.services = {
      docker-ryot_db = {
        after = [ "create-ryot-network.service" "docker.service" "docker.socket" ];
        requires = [ "create-ryot-network.service" "docker.service" "docker.socket" ];
      };

      docker-ryot = {
        after = [ "create-ryot-network.service" "create-proxy-network.service" "docker.service" "docker.socket" ];
        requires = [ "create-ryot-network.service" "create-proxy-network.service" "docker.service" "docker.socket" ];
      };
    };
  };
}
