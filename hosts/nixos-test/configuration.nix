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
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/vda";
      efiSupport = false;
      useOSProber = true;
    };
  };

  # Limit the number of generations to keep
  # boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.grub.configurationLimit = 10;

  networking.hostName = "nixos-vm"; # Define your hostname.
  users.users.florian.initialPassword = "test";

  # Configure for testing in vm
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 8192; # Use 8192MiB memory.
      cores = 8;
      forwardPorts = [
        { from = "host"; host.port = 8888; guest.port = 80; }
      ];
      sharedDirectories = {
        home = {
          source = "/home/florian";
          target = "/mnt/shared_home";
        };
      };
    };
  };

  modules.system = {
    server = {
      docker.enable = true;
      openssh.enable = true;
    };

    desktop = {
      plasma = {
        enable = true;
      };
    };

    hardware = {
      keymaps.layout = "us";
    };
  };

  # Run containers
  virtualisation.oci-containers.containers."hello" = {
    image = "docker.io/nginxdemos/hello:latest";

    ports = [
      "9000:80/tcp"
    ];
  };

  services.nginx = {
    enable = true;
    virtualHosts."hello.local" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:9000";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ]; # Opens port 80 for HTTP traffic.
}
