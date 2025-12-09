{ config, lib, pkgs, ... }:

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
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };

    # Load amdgpu driver for Xorg and Wayland
    services.xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
