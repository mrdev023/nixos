{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.system.apps.steam;
in
{
  options.modules.system.apps.steam = {
    enable = mkEnableOption ''
      Enable steam with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.steam.gamescopeSession.enable = true;
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
          OBS_VKCAPTURE = true;
        };
      };
      extraPackages = with pkgs; [ gamescope ];
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    hardware.steam-hardware.enable = true;
  };
}
