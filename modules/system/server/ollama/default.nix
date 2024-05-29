{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.system.server.ollama;
  nvidiaEnabled = config.modules.system.hardware.nvidia.enable;
in
{
  options.modules.system.server.ollama = {
    enable = mkEnableOption ''
      Enable ollama with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;

      acceleration = if config.modules.system.hardware.nvidia.enable then "cuda" else null;
    };
  };
}