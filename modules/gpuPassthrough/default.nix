{ config, pkgs, lib, ... }:
with lib;
{
  options.customModules.gpuPassthrough = {
    enable = mkEnableOption ''
      Enable gpu passthgrouth with my custom configurations
    '';
  };
  config =
    let
      cfg = config.customModules.gpuPassthrough;
    in
      mkIf cfg.enable {
        programs.virt-manager.enable = true;

        virtualisation.libvirtd = {
          enable = true;

          hooks.qemu = {
            is_working = "${pkgs.writeShellScript "testHook.sh" ''
+            touch /tmp/qemu_hook_is_working
+          ''}";
          };
        };
      };
}