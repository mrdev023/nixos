{ config, nixgl, pkgs, ... }:

{
  imports = [
    ../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian/distrobox/kdedev";
  };

  modules.home = {
    shell = {
      atuin.enable = true;
      direnv.enable = true;
      git.enable = true;
      lazygit.enable = true;
      zsh.enable = true;
    };

    editors.neovim.enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-qt;
    };

    yubikey-agent.enable = true;
  };

  programs.gpg = {
    enable = true;

    # Requires: ccid package installed and pcscd system service started
    scdaemonSettings = {
      disable-ccid = true;
    };
  };
}
