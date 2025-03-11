{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.hardware.graphics.amdgpu;
in
{
  options.modules.system.hardware.graphics.amdgpu = {
    enable = mkEnableOption ''
      Enable amdgpu with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "amdgpu" ];
    # Load amdgpu driver for Xorg and Wayland
    services.xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    };
  };
}
