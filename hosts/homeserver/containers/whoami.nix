{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.containers.whoami;
  cfgContainers = config.services.containers;
in
{
  options.services.containers.whoami = {
    enable = mkEnableOption "Whoami container service";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      whoami = {
        image = "containous/whoami";
        autoStart = true;
        extraOptions = [
          "--network=proxy"
          "--label=traefik.enable=true"
          "--label=traefik.http.routers.whoami-secure.entrypoints=https"
          "--label=traefik.http.routers.whoami-secure.rule=Host('whoami.${cfgContainers.domain}')"
          "--label=traefik.http.routers.whoami-secure.tls=true"
          "--label=traefik.http.routers.whoami-secure.tls.certresolver=sslResolver"
          "--label=traefik.http.routers.whoami-secure.middlewares=private-network@file"
          "--label=traefik.docker.network=proxy"
        ];
      };
    };
  };
}