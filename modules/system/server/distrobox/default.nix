{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.system.server.distrobox;
in
{
  options.modules.system.server.distrobox = {
    enable = mkEnableOption ''
      Enable distrobox with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    modules.system.server.docker.enable = true;
    environment.systemPackages = with pkgs; [ distrobox ];
  };
}