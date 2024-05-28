{ config, pkgs, ... }:

{
  imports = [
    ./docker
    ./openssh
  ];
}