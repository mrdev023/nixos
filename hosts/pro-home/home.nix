{ config, nixgl, pkgs, ... }:

{
  imports = [
    ../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  nixGL = {
    packages = nixgl.packages;
    installScripts = ["mesa"];
  };

  modules.home = {
    apps = {
      kitty = {
        enable = true;
        package = config.lib.nixGL.wrap pkgs.kitty;
      };
    };

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
