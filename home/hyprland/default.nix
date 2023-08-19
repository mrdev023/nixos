{
  pkgs,
  inputs,
  ...
} @ args: {
  home.packages = [];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    # settings = import ./settings.nix args;
  };
}