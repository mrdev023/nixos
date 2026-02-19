{
  config,
  lib,
  pkgs,
  ...
}:

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
    nixpkgs.config.rocmSupport = true;

    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };

    # Load amdgpu driver for Xorg and Wayland
    services.xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # https://hydra.nixos.org/build/321902794/nixlog/1
    # systemd.tmpfiles.rules =
    #   let
    #     rocmEnv = pkgs.symlinkJoin {
    #       name = "rocm-combined";
    #       paths = with pkgs.rocmPackages; [
    #         rocblas
    #         hipblas
    #         clr
    #       ];
    #     };
    #   in
    #   [
    #     "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    #   ];
  };
}
