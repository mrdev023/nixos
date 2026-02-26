{ config, ... }:

{
  imports = [
    ../common.nix
    ./apps
    ./configs
    ./desktop
    ./editors
    ./profiles.nix
    ./shell
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "${config.home.homeDirectory}/Bureau";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Téléchargements";
    music = "${config.home.homeDirectory}/Musique";
    pictures = "${config.home.homeDirectory}/Images";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Modèles";
    videos = "${config.home.homeDirectory}/Vidéos";

    extraConfig = {
      PROJECTS = "${config.home.homeDirectory}/Projets";
    };
  };
}
