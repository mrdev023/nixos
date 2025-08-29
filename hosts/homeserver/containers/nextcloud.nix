{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.containers.nextcloud;
  cfgContainers = config.services.containers;
in
{
  options.services.containers.nextcloud = {
    enable = mkEnableOption "Nextcloud container service";
  };

  config = mkIf cfg.enable {
    systemd.services.create-nextcloud-network = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.lib.getExe pkgs.docker} network inspect nextcloud-internal >/dev/null 2>&1 || \
        ${pkgs.lib.getExe pkgs.docker} network create nextcloud-internal
      '';
    };

    virtualisation.oci-containers.containers = {
      nextcloud_db = {
        image = "postgres:14";
        autoStart = true;
        volumes = [
          "${cfgContainers.workPath}/nextcloud/db:/var/lib/postgresql/data"
        ];
        environment = {
          POSTGRES_DB = "nextcloud";
          POSTGRES_USER = "nextcloud";
          POSTGRES_PASSWORD = "nextcloud";
        };
        extraOptions = [
          "--network=nextcloud-internal"
        ];
      };

      nextcloud = {
        image = "nextcloud";
        autoStart = true;
        volumes = [
          "${cfgContainers.workPath}/nextcloud/base:/var/www/html"
        ];
        environment = {
          POSTGRES_HOST = "nextcloud_db";
          POSTGRES_DB = "nextcloud";
          POSTGRES_USER = "nextcloud";
          POSTGRES_PASSWORD = "nextcloud";
          OVERWRITEPROTOCOL = "https";
        };
        dependsOn = [
          "nextcloud_db"
        ];
        extraOptions = [
          "--network=nextcloud-internal"
          "--network=proxy"
          "--label=traefik.enable=true"
          "--label=traefik.http.middlewares.nextcloud-compress.compress=true"
          "--label=traefik.http.middlewares.nextcloud-caldav.redirectregex.permanent=true"
          "--label=traefik.http.middlewares.nextcloud-caldav.redirectregex.regex='https://(.*)/.well-known/(card|cal)dav'"
          "--label=traefik.http.middlewares.nextcloud-caldav.redirectregex.replacement='https://$\${1}/remote.php/dav/'"
          "--label=traefik.http.middlewares.nextcloud-headers.headers.customRequestHeaders.X-Forwarded-Proto=https"
          "--label=traefik.http.middlewares.nextcloud-headers.headers.customRequestHeaders.X-Forwarded-Host=mycld.${cfgContainers.domain}"
          "--label=traefik.http.routers.nextcloud-secure.entrypoints=https"
          "--label=traefik.http.routers.nextcloud-secure.rule=Host(`mycld.${cfgContainers.domain}`)"
          "--label=traefik.http.routers.nextcloud-secure.tls=true"
          "--label=traefik.http.routers.nextcloud-secure.tls.certresolver=sslResolver"
          "--label=traefik.http.routers.nextcloud-secure.middlewares=nextcloud-caldav,nextcloud-headers,nextcloud-compress"
          "--label=traefik.docker.network=proxy"
        ];
      };
    };

    systemd.services = {
      docker-nextcloud_db = {
        after = [ "create-nextcloud-network.service" "docker.service" "docker.socket" ];
        requires = [ "create-nextcloud-network.service" "docker.service" "docker.socket" ];
      };

      docker-nextcloud = {
        after = [ "create-nextcloud-network.service" "create-proxy-network.service" "docker.service" "docker.socket" ];
        requires = [ "create-nextcloud-network.service" "create-proxy-network.service" "docker.service" "docker.socket" ];
      };
    };
  };
}