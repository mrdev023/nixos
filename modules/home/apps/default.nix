{ config, pkgs, ... }:

{
  imports = [
    ./chromium
    ./firefox
    ./flatpak
    ./jetbrainsToolbox
    ./kitty
  ];
}
