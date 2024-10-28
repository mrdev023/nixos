{ ... }:

{
  imports = [
    ../common.nix
    ./apps
    ./editors
    ./desktop
    ./shell
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";

    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}

