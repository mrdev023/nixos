{ ... }:

{
  imports = [
    ./apps
    ./boot
    ./desktop
    ./hardware
    ./services

    # Common configuration
    ./common.nix
  ];
}