# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/system.nix
      ../../modules/network.nix
      ../../modules/keymaps/us.nix
      ../../modules/pipewire.nix
      ../../modules/plasma.nix
      ../../modules/plymouth.nix

      ../../modules # Import optional configuration
  
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/vda";
      efiSupport = false;
      useOSProber = true;
    };
  };

  # Configure for testing in vm
  users.users.florian.initialPassword = "test";
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 8192; # Use 8192MiB memory.
      cores = 8;         
    };
  };

  networking.hostName = "nixos-vm"; # Define your hostname.
}
