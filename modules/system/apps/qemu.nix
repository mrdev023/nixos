{ config, pkgs, lib, ... }:

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

    users.groups.libvirtd.members = ["florian"];
    users.users.florian.extraGroups = [ "libvirtd" ];

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
