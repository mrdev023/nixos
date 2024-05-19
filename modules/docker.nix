{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = config.hardware.nvidia.modesetting.enable;
  users.users.florian.extraGroups = [ "docker" ];
}
