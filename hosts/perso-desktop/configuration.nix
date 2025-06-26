# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

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

  networking.hostName = "nixos-desktop-perso"; # Define your hostname.

  modules.system = {
    apps = {
      flatpak.enable = true;
      steam.enable = true;
      qemu.enable = true;
      lutris.enable = true;
    };

    boot.plymouth.enable = true;

    desktop = {
      plasma = {
        enable = true;
      };
    };

    hardware = {
      bluetooth.enable = true;
      gamingKernel.enable = true;
      keymaps.layout = "us";
      graphics.amdgpu.enable = true;
      audio.pipewire.enable = true;
      printing.enable = true;
      steering-wheel.enable = true;
    };
  };

  # Revert to RADV when this https://gitlab.freedesktop.org/mesa/mesa/-/issues/12865 is resolved
  chaotic.mesa-git = {
    enable = true;
    # NOTE: Fixed when https://github.com/NixOS/nixpkgs/pull/418461 is available
    # rocmPackages.clr.icd 
    extraPackages = with pkgs; [ amdvlk ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };

  networking.interfaces.enp17s0.wakeOnLan.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      linux-firmware = super.linux-firmware.overrideAttrs (old: rec {
        pname = "linux-firmware";
        version = "20250625";
        src = super.fetchFromGitLab {
          owner = "kernel-firmware";
          repo = "linux-firmware";
          rev = "cbbce56d6dcc1ec8fb485dfb92c68cb9acd51410";
          hash = "sha256-7XN2g4cnHLnICs/ynt8dCpTJbbBkbOdtRm3by/XrDps=";
        };
      });
    })
  ];

  warnings = [ "linux-firmware pinned to 20250625. Remove it when https://github.com/NixOS/nixpkgs/issues/419838 is fixed." ];
}
