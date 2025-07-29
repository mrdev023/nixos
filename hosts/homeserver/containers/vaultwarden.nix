{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.containers.vaultwarden;
  cfgContainers = config.services.containers;
in
{
  options.services.containers.vaultwarden = {
    enable = mkEnableOption "Vaultwarden container service";
  };

  config = mkIf cfg.enable {
  virtualisation.oci-containers.containers = {
    vaultwarden_db = {
      image = "postgres:15";
      autoStart = true;
      volumes = [
        "${cfgContainers.workPath}/vaultwarden/db:/var/lib/postgresql/data"
      ];
      environment = {
        POSTGRES_DB = "vaultwarden";
        POSTGRES_USER = "vaultwarden";
        POSTGRES_PASSWORD = "vaultwarden";
      };
      extraOptions = [
        "--network=vaultwarden-internal"
      ];
    };

    vaultwarden = {
      image = "vaultwarden/server:latest";
      autoStart = true;
      volumes = [
        "${cfgContainers.workPath}/vaultwarden/data:/data"
      ];
      environment = {
        DATABASE_URL = "postgresql://vaultwarden:vaultwarden@vaultwarden_db/vaultwarden";
        WEBSOCKET_ENABLED = "true";
        SIGNUPS_ALLOWED = "false";
        ADMIN_TOKEN = "your_admin_token_here";
      };
      dependsOn = [
        "vaultwarden_db"
      ];
      extraOptions = [
        "--network=vaultwarden-internal"
        "--network=proxy"
        "--label=traefik.enable=true"
        "--label=traefik.http.routers.bitwarden-ui-https.entrypoints=https"
        "--label=traefik.http.routers.bitwarden-ui-https.rule=Host('pwds.${cfgContainers.domain}')"
        "--label=traefik.http.routers.bitwarden-ui-https.tls=true"
        "--label=traefik.http.routers.bitwarden-ui-https.tls.certresolver=sslResolver"
        "--label=traefik.http.routers.bitwarden-ui-http.rule=Host('pwds.${cfgContainers.domain}')"
        "--label=traefik.http.routers.bitwarden-ui-http.middlewares=redirect-https"
        "--label=traefik.http.routers.bitwarden-websocket-https.entrypoints=https"
        "--label=traefik.http.routers.bitwarden-websocket-https.rule=Host('pwds.${cfgContainers.domain}') && Path('/notifications/hub')"
        "--label=traefik.http.routers.bitwarden-websocket-https.tls=true"
        "--label=traefik.http.routers.bitwarden-websocket-https.tls.certresolver=sslResolver"
        "--label=traefik.http.routers.bitwarden-websocket-http.rule=Host('pwds.${cfgContainers.domain}') && Path('/notifications/hub')"
        "--label=traefik.http.routers.bitwarden-websocket-http.middlewares=redirect-https"
        "--label=traefik.http.services.bitwarden-ui.loadbalancer.server.port=80"
        "--label=traefik.http.services.bitwarden-websocket.loadbalancer.server.port=3012"
        "--label=traefik.docker.network=proxy"
      ];
    };
  };

    # Create the necessary directories
    system.activationScripts.vaultwarden-dirs = ''
      mkdir -p ${cfgContainers.workPath}/vaultwarden/db
      mkdir -p ${cfgContainers.workPath}/vaultwarden/data
    '';

    # Create networks
    systemd.services.create-vaultwarden-network = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.podman}/bin/podman network exists vaultwarden-internal || \
        ${pkgs.podman}/bin/podman network create vaultwarden-internal
      '';
    };
  };
}