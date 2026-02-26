{ lib, pkgs, ... }:

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
    systemd.services.create-proxy-network = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "multi-user.target" ];
      after = [
        "docker.service"
        "docker.socket"
      ];
      requires = [
        "docker.service"
        "docker.socket"
      ];
      script = ''
        ${pkgs.lib.getExe pkgs.docker} network inspect proxy >/dev/null 2>&1 || \
        ${pkgs.lib.getExe pkgs.docker} network create proxy
      '';
    };

    systemd.services.create-metrics-network = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "multi-user.target" ];
      after = [
        "docker.service"
        "docker.socket"
      ];
      requires = [
        "docker.service"
        "docker.socket"
      ];
      script = ''
        ${pkgs.lib.getExe pkgs.docker} network inspect metrics >/dev/null 2>&1 || \
        ${pkgs.lib.getExe pkgs.docker} network create metrics
      '';
    };
  };

  imports = [
    ./traefik.nix
    ./nextcloud.nix
    ./home-assistant.nix
    ./ryot.nix
    ./vaultwarden.nix
    ./watchtower.nix
    ./whoami.nix
    ./forgejo.nix
    ./portfolio.nix
  ];
}
