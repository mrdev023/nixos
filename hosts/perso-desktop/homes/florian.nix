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
    discord.enable = true; # Vesktop have a bug with screenshare
    spicetify.enable = true;
    zen-browser.enable = true;
    zed-editor.enable = true;
  };

  services.flatpak.enable = true;

  modules.home.profiles = [ "shell" ];

  home.packages = [
    inputs.nix-citizen.packages.${system}.rsi-launcher
  ];

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/Projets/Perso/DevOps/nixos";
}
