{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  users.users.florian.extraGroups = [ "docker" ];
}
