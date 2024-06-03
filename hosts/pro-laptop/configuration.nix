# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/system

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-laptop-pro"; # Define your hostname.

  modules.system = {
    desktop = {
      plasma.enable = true;
    };

    hardware = {
      bluetooth.enable = true;
      gamingKernel.enable = true;
      keymaps.layout = "fr";
      nvidia.enable = true;
      pipewire.enable = true;
      plymouth.enable = true;
      printing.enable = true;
      waydroid.enable = true;
    };
  };
}
