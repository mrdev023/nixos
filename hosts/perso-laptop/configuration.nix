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

  networking.hostName = "nixos-laptop-perso"; # Define your hostname.

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    # Make sure to use the correct Bus ID values for your system!
    # information bus: pci@0000:00:02.0
    intelBusId = "PCI:0:2:0";
    # information bus: pci@0000:01:00.0
    nvidiaBusId = "PCI:1:0:0";
  };

  modules.system = {
    apps = {
      flatpak.enable = true;
    };

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
