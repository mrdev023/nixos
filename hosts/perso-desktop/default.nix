# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/linux_gaming.nix
      ../../modules/system.nix
      ../../modules/network.nix
      ../../modules/nvidia.nix
      ../../modules/plasma.nix
      ../../modules/keymaps/us.nix
      ../../modules/bluetooth.nix
      ../../modules/pipewire.nix
      ../../modules/docker.nix

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-desktop-perso"; # Define your hostname.
}
