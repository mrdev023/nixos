{ config, lib, pkgs, ... }:

with lib;
{
  options.services.containers = {
    workPath = mkOption {
      type = types.str;
      description = "Base path for container data storage";
      example = "/mnt/work";
    };
    
    domain = mkOption {
      type = types.str;
      description = "Domain name for Traefik routing";
      example = "example.com";
    };
  };

  config = {
    # Create shared proxy network for Traefik (using Docker backend)
    systemd.services.create-proxy-network = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "multi-user.target" ];
      after = [ "docker.service" "docker.socket" ];
      requires = [ "docker.service" "docker.socket" ];
      script = ''
        ${pkgs.docker}/bin/docker network inspect proxy >/dev/null 2>&1 || \
        ${pkgs.docker}/bin/docker network create proxy
      '';
    };
  };

  imports = [
    ./traefik.nix
    # ./cloud.nix
    # ./home-assistant.nix
    # ./ryot.nix
    # ./vaultwarden.nix
    # ./watchtower.nix
    # ./whoami.nix
  ];
}