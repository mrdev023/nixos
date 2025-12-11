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
    warnings = [
      "hardware.firmware.linux-firmware override to 20251111 to fix amdgpu issues. See https://github.com/NixOS/nixpkgs/issues/466945. Remove the override when fixed."
    ];
    hardware.firmware = [
      (pkgs.linux-firmware.overrideAttrs (old: {
        version = "20251111";
        src = pkgs.fetchurl {
          # https://www.kernel.org/pub/linux/kernel/firmware/
          url = "https://www.kernel.org/pub/linux/kernel/firmware/linux-firmware-20251111.tar.gz";
          # > nix-prefetch-url https://www.kernel.org/pub/linux/kernel/firmware/linux-firmware-20251111.tar.gz
          sha256 = "0rp2ah8drcnl7fh9vbawa8p8c9lhvn1d8zkl48ckj20vba0maz2g";
        };
      }))
    ];

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
  };
}
