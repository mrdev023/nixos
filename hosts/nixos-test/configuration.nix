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
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/vda";
      efiSupport = false;
      useOSProber = true;
    };
  };

  networking.hostName = "nixos-vm"; # Define your hostname.
  users.users.florian.initialPassword = "test";

  # Configure for testing in vm
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 8192; # Use 8192MiB memory.
      cores = 8;         
    };
  };

  modules.system = {
    desktop = {
      plasma.enable = true;
    };

    server = {
      docker.enable = true;
      openssh.enable = true;
    };

    hardware = {
      bluetooth.enable = true;
      gamingKernel.enable = true;
      keymaps.layout = "us";
      pipewire.enable = true;
      plymouth.enable = true;
      printing.enable = true;
      waydroid.enable = true;
    };
  };
}
