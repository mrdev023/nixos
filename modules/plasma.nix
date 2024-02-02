{ pkgs, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };
}
