{
  nix-citizen,
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

    configs.distrobox.enable = true;

    profiles = [ "shell" ];
  };

  home.packages = [
    nix-citizen.packages.${system}.rsi-launcher
    pkgs.claude-code
  ];

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/Projets/Perso/DevOps/nixos";
}
