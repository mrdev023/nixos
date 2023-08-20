{ pkgs, ... }:

{
  programs.hyprland.enable = true;

  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];
  };
}