{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.containers;
in
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
    # Create shared proxy network for Traefik
    systemd.services.create-proxy-network = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.podman}/bin/podman network exists proxy || \
        ${pkgs.podman}/bin/podman network create proxy
      '';
    };
  };

  imports = [
    ./cloud.nix
    ./home-assistant.nix
    ./ryot.nix
    ./vaultwarden.nix
    ./watchtower.nix
    ./whoami.nix
  ];
}