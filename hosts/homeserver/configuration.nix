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

  modules.system = {
    services = {
      docker = {
        enable = true;
        dataRoot = "/mnt/work/docker";
      };
      openssh.enable = true;
    };
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
  
  virtualisation.docker.autoPrune.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCpXeXoU/vzenegBqL/xhJ3cHQDPcyG3uapNOTrKMNQ9Nx9hMTvQp2Wqb9lkj+atYtYv7PkGZhXdRrQbCuDyUx7skZ9k5hOsnp9rFrkXeFDNY42HZNX+sek87nOvnNm/PfRgL3Gu1aJLrwa/weGn9uw4SGcMtThhVQkSGiG6JhRpo58gqvWd4E+vuvA08KXsXiv5xB/7Lzedqsgkqpu2pOlgd3G//ztVPlNZxko4bKyj5Ymr95PSe45CUy0zuyF+hgSNTkyAMw9hm5+SShT3G78Yhk5fyBDZO6uQJbktw2DTGS8ranr0e9FE6UyE1tmjmls7Zz/3276A0Y29G6JbW7Fc/yH0R8Yz23ZoMGX6iXhRXnfar/bqN07aEOenPub3IykuRaZ2RmBbOgvkKeHQCqT701C3IgHUmb6j6UAl7Ka34oNQQDCzvvuqwaSXPwhrD1tHdWFEYlQIP6o+Wh2GctlaTWA25TrdokF5Ln4yIaVCoi6vsvkmjCZZOmTfPOV4U= florian@florian-aero15xa"
  ];

  # Configure for testing in vm
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 8;
      diskSize = 16 * 1024;
      forwardPorts = [
        { from = "host"; host.port = 2222; guest.port = 22; }
      ];
    };
  };
}
