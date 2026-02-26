{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.system.apps.qemu;
in
{
  options.modules.system.apps.qemu = {
    enable = mkEnableOption ''
      Enable qemu with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
