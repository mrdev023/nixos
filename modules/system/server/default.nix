{ config, pkgs, ... }:

{
  imports = [
    ./docker
    ./ollama
    ./openssh
  ];
}