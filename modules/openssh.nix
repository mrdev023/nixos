{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    passwordAuthentication = true;
    listenAddresses = [
      {
        addr = "192.168.1.0/24";
        port = "22";
      }
    ];
  };
}