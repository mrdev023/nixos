{ ... }:

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
}

