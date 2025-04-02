{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.services.ollama;
in
{
  options.modules.system.services.ollama = {
    enable = mkEnableOption ''
      Enable ollama with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
    };
  };
}
