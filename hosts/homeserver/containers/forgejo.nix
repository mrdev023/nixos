{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.containers.forgejo;
  cfgContainers = config.services.containers;
  runnerConfig = pkgs.writers.writeYAML "config.yml" {
    cache = {
      enabled = true;
      dir = "";
      host = "";
      port = 8088;
    };
    container = {
      network = "git_default";
    };
  };
in
{
  options.services.containers.forgejo = {
    enable = mkEnableOption "Forgejo container service";
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      forgejo_env = {
        sopsFile = ../../../secrets/forgejo.env;
        format = "dotenv";
      };
    };

    virtualisation.oci-containers.containers = {
      forgejo = {
        image = "codeberg.org/forgejo/forgejo:12";
        autoStart = true;
        volumes = [
          "${cfgContainers.workPath}/forgejo/data:/data"
          "/etc/timezone:/etc/timezone:ro"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          USER_UID = "1000";
          USER_GID = "1000";
          FORGEJO__service__DISABLE_REGISTRATION = "true";
          FORGEJO__actions__ENABLED = "true";
          FORGEJO__actions__DEFAULT_ACTIONS_URL = "self";
          FORGEJO__packages__ENABLED = "true";
        };
        extraOptions = [
          "--network=proxy"
          "--label=traefik.enable=true"
          "--label=traefik.http.routers.git-secure.entrypoints=https"
          "--label=traefik.http.routers.git-secure.rule=Host(`git.${cfgContainers.domain}`)"
          "--label=traefik.http.routers.git-secure.tls=true"
          "--label=traefik.http.routers.git-secure.tls.certresolver=sslResolver"
          "--label=traefik.http.routers.git-secure.service=git"
          "--label=traefik.http.services.git.loadbalancer.server.port=3000"
          # TCP SSH Reverse proxy (requires an 'ssh' Traefik entrypoint configured on host)
          "--label=traefik.tcp.routers.git-ssh.rule=HostSNI(`*`)"
          "--label=traefik.tcp.routers.git-ssh.entrypoints=ssh"
          "--label=traefik.tcp.routers.git-ssh.service=git-ssh"
          "--label=traefik.tcp.services.git-ssh.loadbalancer.server.port=22"
          "--label=traefik.docker.network=proxy"
        ];
      };

      forgejo_runner = {
        image = "gitea/act_runner";
        autoStart = true;
        dependsOn = [ "forgejo" ];
        volumes = [
          "${runnerConfig}:/config.yml:ro"
          "${cfgContainers.workPath}/gitea/runner:/data"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        environment = {
          CONFIG_FILE = "/config.yml";
          GITEA_INSTANCE_URL = "https://git.${cfgContainers.domain}";
        };
        environmentFiles = [
          config.sops.secrets.forgejo_env.path 
        ];
      };
    };

    systemd.services = {
      docker-forgejo = {
        after = [ "create-proxy-network.service" "docker.service" "docker.socket" ];
        requires = [ "create-proxy-network.service" "docker.service" "docker.socket" ];
      };
      docker-forgejo_runner = {
        after = [ "docker.service" "docker.socket" ];
        requires = [ "docker.service" "docker.socket" ];
      };
    };
  };
}


