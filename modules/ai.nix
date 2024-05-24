{ config, pkgs, lib, ... }:
with lib;
{
  options.customModules.AI = {
    enable = mkEnableOption ''
      Enable AI
    '';
  };
  config =
    let
      cfg = config.customModules.AI;
      nvidiaEnabled = config.hardware.nvidia.modesetting.enable;
    in
      mkIf cfg.enable {
        services.ollama = {
          enable = true;

          acceleration = 
            if nvidiaEnabled then
              "cuda"
            else
              null;
        };
      }
      // mkIf nvidiaEnabled { environment.systemPackages = with pkgs; [cudatoolkit]; };
}