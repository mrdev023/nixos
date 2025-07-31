# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ ... }:

{
  imports = [
    ../../modules/system

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko-config.nix
    ./containers
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

  services.containers = {
    workPath = "/mnt/work";
    domain = "mrdev023.fr";
    
    # Enable all container services
    nextcloud.enable = true;
    home-assistant.enable = true;
    vaultwarden.enable = true;
    ryot.enable = true;
    whoami.enable = true;
    watchtower.enable = true;
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
