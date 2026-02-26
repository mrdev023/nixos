{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.system.hardware.secure-boot;
in
{
  options.modules.system.hardware.secure-boot = {
    enable = mkEnableOption ''
      Enable printing with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      # For debugging and troubleshooting Secure Boot.
      pkgs.sbctl
    ];

    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
