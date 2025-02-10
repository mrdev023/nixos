{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.home.editors.neovim;
in
{
  options.modules.home.editors.neovim = {
    enable = mkEnableOption ''
      Enable neovim with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    # Source : https://www.lazyvim.org/
    modules.home.apps.kitty.enable = lib.mkDefault true;
    modules.home.shell.git.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      lazygit
      curl
      gnutar
      fzf
      ripgrep
      fd
      gcc

      unzip
      cargo
      python3
      nodejs
      nil
      rust-analyzer
      clang-tools
    ];
  };
}
