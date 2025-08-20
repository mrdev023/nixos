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

    environment.systemPackages = with pkgs; [
      mangohud
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      MANGOHUD_CONFIG = ''no_display,control=mangohud,legacy_layout=0,vertical,background_alpha=0,gpu_stats,gpu_power,cpu_stats,core_load,ram,vram,fps,fps_metrics=AVG,0.001,frametime,refresh_rate,resolution,gpu_name,vulkan_driver,wine'';
    };
  };
}
