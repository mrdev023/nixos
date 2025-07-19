{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.services.monado;
in
{
  options.modules.system.services.monado = {
    enable = mkEnableOption ''
      Enable monado with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    # https://github.com/NixOS/nixpkgs/issues/258196
    services.monado = {
      enable = true;
      defaultRuntime = true;
    };
    
    systemd.user.services.monado.environment = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
    };

    environment.variables = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
      WMR_HANDTRACKING = "0";

      VIT_SYSTEM_LIBRARY_PATH = "${pkgs.basalt-monado}/lib/libbasalt.so";
    };

    home-manager.users.florian.home.file.".local/share/monado/hand-tracking-models".source =
      pkgs.fetchgit
      {
        url = "https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models";
        sha256 = "x/X4HyyHdQUxn3CdMbWj5cfLvV7UyQe1D01H93UCk+M=";
        fetchLFS = true;
      };
  };
}