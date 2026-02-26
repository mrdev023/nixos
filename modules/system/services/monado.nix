{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfgAmdgpu = config.modules.system.hardware.graphics.amdgpu;
  cfg = config.modules.system.services.monado;
in
{
  options.modules.system.services.monado = {
    enable = mkEnableOption ''
      Enable monado with my custom configurations
    '';

    enableAmdgpuPatch = mkOption {
      type = types.bool;
      description = "Patch kernel to disable CAP_SYS_NICE on amdgpu. Required to allow high priority queues.";
      default = cfgAmdgpu.enable;
    };
  };
  config = mkIf cfg.enable {
    # https://wiki.nixos.org/wiki/VR
    # https://github.com/NixOS/nixpkgs/issues/258196
    #
    # Monado can be run with the following commands:
    #   systemctl --user start monado.service
    #   systemctl --user stop monado.{service,socket}
    #   journalctl --user --follow --unit monado.service
    # Games require LAUNCH OPTIONS: "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%"
    #
    # Requires also `configs.monado.enable = true;` in home.nix for the user to work well
    #
    # On NVIDIA it requires 60hz so it's needed to set XRT_COMPOSITOR_DESIRED_MODE with the index of the mode
    # use XRT_COMPOSITOR_PRINT_MODES=true to show all available modes

    services.monado = {
      enable = true;
      defaultRuntime = true;
      forceDefaultRuntime = true;
    };

    systemd.user.services.monado.environment = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
      WMR_HANDTRACKING = "1";

      # Enable debugging if needed
      XRT_DEBUG_GUI = "0";
    };

    boot.kernelPatches = mkIf cfg.enableAmdgpuPatch [
      {
        name = "amdgpu-ignore-ctx-privileges";
        patch = pkgs.fetchpatch {
          name = "cap_sys_nice_begone.patch";
          url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
          hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
        };
      }
    ];
  };
}
