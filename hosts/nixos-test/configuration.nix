# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ ... }:

{
  imports = [
    ../../modules/system

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;
  # boot.loader.grub.configurationLimit = 10;

  networking.hostName = "nixos-test-perso"; # Define your hostname.

  modules.system = {
    boot.plymouth.enable = true;

    desktop = {
      plasma.enable = true;
      hyprland.enable = true;
    };

    hardware = {
      gamingKernel.enable = true;
      keymaps.layout = "us";
      audio.pipewire.enable = true;
      printing.enable = true;
    };
  };

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 8192; # Use 8192MiB memory.
      cores = 4;
      # And more here https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/virtualisation/qemu-vm.nix
    };
  };
}
