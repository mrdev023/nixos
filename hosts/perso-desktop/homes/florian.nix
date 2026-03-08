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

  modules.home = {
    apps.flatpak.enable = true;
    apps.discord.enable = true;
    apps.scrcpy.enable = true;
    apps.zen-browser.enable = true;
    apps.spotify.enable = true;

    desktop.hyprland.enable = true;

    profiles = [ "shell" ];
  };

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1, 5120x1440@240, 0x0, 1, vrr, 1, bitdepth, 10, cm, hdr, sdrbrightness, 1.3, sdrsaturation, 0.97"
  ];

  home.packages = [
    inputs.nix-citizen.packages.${system}.rsi-launcher
  ];

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/Projets/Perso/DevOps/nixos";
}
