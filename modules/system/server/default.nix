{ config, pkgs, ... }:

{
  imports = [
    ./distrobox
    ./docker
    ./ollama
    ./openssh
  ];
}