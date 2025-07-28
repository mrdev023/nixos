# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/system

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko-config.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "nixos-homeserver"; # Define your hostname.

  modules.system.services.docker = {
    enable = true;
    dataRoot = "/mnt/work/docker";
  };

  services.borgbackup.jobs.workBackup = {
    paths = "/mnt/work";
    encryption.mode = "none";
    exclude = [ "docker" ];
    repo = "/mnt/backup";
    compression = "zstd,22";
    startAt = "daily";
    dateFormat = "--iso-8601=seconds";
    archiveBaseName = null;
  };
}
