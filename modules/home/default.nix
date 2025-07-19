{ ... }:

{
  imports = [
    ../common.nix
    ./apps
    ./configs
    ./editors
    ./desktop
    ./shell
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";

    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}

