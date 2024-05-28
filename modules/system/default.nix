{ config, pkgs, ... }:

{
  imports = [
    ./desktop
    ./hardware
    ./server

    # Common configuration
    ./common.nix
  ];
}