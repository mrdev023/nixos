{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.system.services.distrobox;
in
{
  options.modules.system.services.distrobox = {
    enable = mkEnableOption ''
      Enable distrobox with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    modules.system.services.docker.enable = true;
    environment.systemPackages = with pkgs; [ distrobox ];
  };
}