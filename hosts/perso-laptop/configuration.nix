# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, ... }:

{
  imports =
    [
      ../../modules/system

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./disko-config.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;
  # boot.loader.grub.configurationLimit = 10;

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
      appimage.enable = true;
      flatpak.enable = true;
      lutris.enable = true;
      steam.enable = true;
    };

    boot.plymouth.enable = true;

    desktop = {
      plasma.enable = true;
    };

    hardware = {
      bluetooth.enable = true;
      gamingKernel.enable = true;
      keymaps.layout = "fr";
      graphics.nvidia.enable = true;
      audio.pipewire.enable = true;
      printing.enable = true;
      waydroid.enable = true;
    };
  };
}
