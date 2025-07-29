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
    virtualisation.oci-containers.containers = {
      ryot_db = {
        image = "postgres:16";
        autoStart = true;
        volumes = [
          "${cfgContainers.workPath}/ryot/db:/var/lib/postgresql/data"
        ];
        environment = {
          POSTGRES_DB = "ryot";
          POSTGRES_USER = "ryot"; 
          POSTGRES_PASSWORD = "ryot";
        };
        extraOptions = [
          "--network=ryot-internal"
        ];
      };

      ryot = {
        image = "ghcr.io/ignisda/ryot:latest";
        autoStart = true;
        volumes = [
          "${cfgContainers.workPath}/ryot/data:/data"
        ];
        environment = {
          DATABASE_URL = "postgres://ryot:ryot@ryot_db:5432/ryot";
        };
        dependsOn = [
          "ryot_db"
        ];
        extraOptions = [
          "--network=ryot-internal"
          "--network=proxy"
          "--label=traefik.enable=true"
          "--label=traefik.http.routers.ryot-secure.entrypoints=https"
          "--label=traefik.http.routers.ryot-secure.rule=Host('ryot.${cfgContainers.domain}')"
          "--label=traefik.http.routers.ryot-secure.tls=true"
          "--label=traefik.http.routers.ryot-secure.tls.certresolver=sslResolver"
          "--label=traefik.http.routers.ryot-secure.middlewares=private-network@file"
          "--label=traefik.http.services.ryot.loadbalancer.server.port=8000"
          "--label=traefik.docker.network=proxy"
        ];
      };
    };

    # Create the necessary directories
    system.activationScripts.ryot-dirs = ''
      mkdir -p ${cfgContainers.workPath}/ryot/db
      mkdir -p ${cfgContainers.workPath}/ryot/data
    '';

    # Create networks
    systemd.services.create-ryot-network = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.podman}/bin/podman network exists ryot-internal || \
        ${pkgs.podman}/bin/podman network create ryot-internal
      '';
    };
  };
}
