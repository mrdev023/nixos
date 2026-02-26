{ config, lib, ... }:

with lib;
let
  cfg = config.services.containers.portfolio;
  cfgContainers = config.services.containers;
in
{
  options.services.containers.portfolio = {
    enable = mkEnableOption "Portfolio container service";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.portfolio = {
      image = "gitea.mrdev023.fr/florian.richer/portfolio:latest";
      autoStart = true;
      extraOptions = [
        "--network=proxy"
        "--label=traefik.enable=true"
        "--label=traefik.docker.network=proxy"
        "--label=traefik.http.routers.portfolio-secure.entrypoints=https"
        "--label=traefik.http.routers.portfolio-secure.rule=Host(`${cfgContainers.domain}`)"
        "--label=traefik.http.routers.portfolio-secure.tls=true"
        "--label=traefik.http.routers.portfolio-secure.tls.certresolver=sslResolver"
        "--label=traefik.http.routers.portfolio-secure.service=portfolio"
        "--label=traefik.http.services.portfolio.loadbalancer.server.port=8080"
      ];
    };

    systemd.services.docker-portfolio = {
      after = [
        "create-proxy-network.service"
        "docker.service"
        "docker.socket"
      ];
      requires = [
        "create-proxy-network.service"
        "docker.service"
        "docker.socket"
      ];
    };
  };
}
