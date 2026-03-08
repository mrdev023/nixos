{
  inputs,
  config,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ../../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  programs = {
    obsidian.enable = true;
    vesktop.enable = true;
    spicetify.enable = true;
    zen-browser.enable = true;
  };

  services.flatpak.enable = true;

  modules.home = {
    desktop.hyprland.enable = true;

    profiles = [ "shell" ];
  };

  stylix.image = ../../../assets/backgrounds/ultra_wide.jpg;

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1, 5120x1440@240, 0x0, 1, vrr, 1, bitdepth, 10, cm, hdr, sdrbrightness, 1.3, sdrsaturation, 0.97"
  ];

  home.packages = [
    inputs.nix-citizen.packages.${system}.rsi-launcher
  ];

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/Projets/Perso/DevOps/nixos";
}
