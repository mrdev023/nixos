# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

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

  networking.hostName = "nixos-desktop-perso"; # Define your hostname.

  modules.system = {
    apps = {
      flatpak.enable = true;
      steam.enable = true;
    };

    desktop = {
      plasma = {
        enable = true;
      };
    };

    hardware = {
      bluetooth.enable = true;
      gamingKernel.enable = true;
      keymaps.layout = "us";
      nvidia.enable = true;
      pipewire.enable = true;
      plymouth.enable = true;
      printing.enable = true;
      waydroid.enable = true;
    };

    server = {
      distrobox.enable = true;
    };
  };
}
