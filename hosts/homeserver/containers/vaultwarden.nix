{
  config,
  pkgs,
  lib,
  ...
}:

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
    sops.secrets = {
      vaultwarden_env = {
        sopsFile = ../../../secrets/vaultwarden.env;
        format = "dotenv";
      };
    };

    systemd.services.create-vaultwarden-network = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.lib.getExe pkgs.docker} network inspect vaultwarden-internal >/dev/null 2>&1 || \
        ${pkgs.lib.getExe pkgs.docker} network create vaultwarden-internal
      '';
    };

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
          "${cfgContainers.workPath}/vaultwarden/base:/data"
        ];
        environment = {
          DATABASE_URL = "postgresql://vaultwarden:vaultwarden@vaultwarden_db/vaultwarden";
          WEBSOCKET_ENABLED = "true";
          SIGNUPS_ALLOWED = "false";
          ADMIN_TOKEN = "your_admin_token_here";
          DOMAIN = "https://pwds.${cfgContainers.domain}";
        };
        environmentFiles = [
          config.sops.secrets.vaultwarden_env.path
        ];
        dependsOn = [
          "vaultwarden_db"
        ];
        extraOptions = [
          "--network=vaultwarden-internal"
          "--network=proxy"
          "--label=traefik.enable=true"
          "--label=traefik.http.routers.bitwarden-ui-secure.rule=Host(`pwds.${cfgContainers.domain}`)"
          "--label=traefik.http.routers.bitwarden-ui-secure.entrypoints=https"
          "--label=traefik.http.routers.bitwarden-ui-secure.tls=true"
          "--label=traefik.http.routers.bitwarden-ui-secure.tls.certresolver=sslResolver"
          "--label=traefik.http.routers.bitwarden-ui-secure.service=bitwarden-ui"
          "--label=traefik.http.services.bitwarden-ui.loadbalancer.server.port=80"
          "--label=traefik.http.routers.bitwarden-websocket-secure.rule=Host(`pwds.${cfgContainers.domain}`) && Path(`/notifications/hub`)"
          "--label=traefik.http.routers.bitwarden-websocket-secure.entrypoints=https"
          "--label=traefik.http.routers.bitwarden-websocket-secure.tls=true"
          "--label=traefik.http.routers.bitwarden-websocket-secure.tls.certresolver=sslResolver"
          "--label=traefik.http.routers.bitwarden-websocket-secure.service=bitwarden-websocket"
          "--label=traefik.http.services.bitwarden-websocket.loadbalancer.server.port=3012"
          "--label=traefik.docker.network=proxy"
        ];
      };
    };

    systemd.services = {
      docker-vaultwarden_db = {
        after = [
          "create-vaultwarden-network.service"
          "docker.service"
          "docker.socket"
        ];
        requires = [
          "create-vaultwarden-network.service"
          "docker.service"
          "docker.socket"
        ];
      };

      docker-vaultwarden = {
        after = [
          "create-vaultwarden-network.service"
          "create-proxy-network.service"
          "docker.service"
          "docker.socket"
        ];
        requires = [
          "create-vaultwarden-network.service"
          "create-proxy-network.service"
          "docker.service"
          "docker.socket"
        ];
      };
    };
  };
}
