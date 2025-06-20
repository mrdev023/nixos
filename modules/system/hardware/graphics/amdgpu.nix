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
    warnings = [ "system(hardware.graphics.amdgpu): ROCM Disabled for now. Re-enable it when https://github.com/NixOS/nixpkgs/pull/418461 is available" ];

    boot.initrd.kernelModules = [ "amdgpu" ];

    # Set acceleration to rocm
    # services.ollama.acceleration = "rocm";

    # Load amdgpu driver for Xorg and Wayland
    services.xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
    };

    # NOTE: Fixed when https://github.com/NixOS/nixpkgs/pull/418461 is available
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      # extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    };
  };
}
