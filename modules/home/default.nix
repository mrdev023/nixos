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

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}

