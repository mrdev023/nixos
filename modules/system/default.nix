{ ... }:

{
  imports = [
    ./apps
    ./desktop
    ./hardware
    ./server

    # Common configuration
    ./common.nix
  ];
}