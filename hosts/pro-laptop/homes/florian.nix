{ config, ... }:

{
  imports = [
    ../../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  modules.home = {
    profiles = [ "shell" ];
  };

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/Projets/Perso/nixos";
}
