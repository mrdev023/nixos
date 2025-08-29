{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.containers.traefik;
  cfgContainers = config.services.containers;

  traefikStatic = pkgs.writers.writeTOML "traefik.toml" {
    api.dashboard = true;
    log.level = "INFO";
    accessLog = {};

    entryPoints = {
      ssh.address = ":22";
      http = {
        address = ":80";
        http.redirections.entryPoint = {
          to = "https";
          scheme = "https";
        };
      };
      https.address = ":443";
      metrics.address = ":8080";
    };

    metrics.prometheus = {
      entryPoint = "metrics";
      buckets = [ 0.1 0.3 1.2 5.0 ];
      addEntryPointsLabels = true;
      addServicesLabels = true;
    };

    providers = {
      docker = {
        endpoint = "unix:///var/run/docker.sock";
        exposedByDefault = false;
      };
      file = {
        filename = "/dynamic_conf.toml";
        watch = true;
      };
    };

    certificatesResolvers.sslResolver.acme = {
      email = "florian.richer@protonmail.com";
      tlsChallenge = {};
      storage = "acme.json";
      keyType = "RSA4096";
      # Use only to debug ACME
      # caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
      httpChallenge.entryPoint = "http";
    };
  };

  traefikDynamic = pkgs.writers.writeTOML "dynamic_conf.toml" {
    http.middlewares."private-network".ipWhiteList.sourceRange = [
      # WARN: Remove it before deploy in production
      "0.0.0.0/0"
      "::/0"

      "176.181.127.236"
      "2001:861:52c1:fecf::1"
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
        "--network=metrics"
        "--add-host=host.docker.internal:host-gateway"
        "--label=traefik.enable=true"
        "--label=traefik.http.routers.traefik-secure.entrypoints=https"
        "--label=traefik.http.routers.traefik-secure.rule=Host(`traefik.${cfgContainers.domain}`)"
        "--label=traefik.http.middlewares.tls-rep.redirectregex.permanent=true"
        "--label=traefik.http.middlewares.tls-header.headers.SSLRedirect=true"
        "--label=traefik.http.middlewares.tls-header.headers.forceSTSHeader=true"
        "--label=traefik.http.middlewares.tls-header.headers.STSSeconds=315360000"
        "--label=traefik.http.middlewares.tls-header.headers.STSIncludeSubdomains=true"
        "--label=traefik.http.middlewares.tls-header.headers.STSPreload=true"
        "--label=traefik.http.middlewares.tls-header.headers.browserXSSFilter=true"
        "--label=traefik.http.middlewares.tls-header.headers.contentTypeNosniff=true"
        "--label=traefik.http.middlewares.tls-header.headers.frameDeny=true"
        "--label=traefik.http.middlewares.tls-header.headers.customFrameOptionsValue=SAMEORIGIN"
        "--label=traefik.http.middlewares.tls-header.headers.featurePolicy=accelerometer 'none'; ambient-light-sensor 'none'; camera 'none'; geolocation 'none'; gyroscope 'none'; magnetometer 'none'; microphone 'none'; usb 'none'; midi 'none'; sync-xhr 'none'; vr 'none'"
        "--label=traefik.http.middlewares.tls-header.headers.referrerPolicy=strict-origin-when-cross-origin"
        "--label=traefik.http.middlewares.tls-chain.chain.middlewares=tls-rep,tls-header"
        "--label=traefik.http.routers.traefik-secure.middlewares=tls-chain,private-network@file"
        "--label=traefik.http.routers.traefik-secure.tls=true"
        "--label=traefik.http.routers.traefik-secure.tls.certresolver=sslResolver"
        "--label=traefik.http.routers.traefik-secure.service=api@internal"
      ];
    };

    systemd.services.docker-traefik = {
      after = [ "create-proxy-network.service" "create-metrics-network.service" "docker.service" "docker.socket" ];
      requires = [ "create-proxy-network.service" "create-metrics-network.service" "docker.service" "docker.socket" ];
    };
  };
}


