{ ... }:

{
  imports = [
    ./apps
    ./desktop
    ./hardware
    ./services

    # Common configuration
    ./common.nix
  ];
}