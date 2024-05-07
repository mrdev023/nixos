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

          # hooks.qemu = {
          #   win10 = {
          #     prepare.begin = {

          #     };
          #   };
          # };
        };
      };
}