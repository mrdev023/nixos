{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    listenAddresses = [
      {
        addr = "192.168.1.0";
        port = 22;
      }
    ];

    settings = {
      PasswordAuthentication = true;
    };
  };
}