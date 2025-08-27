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
    profiles = [ "shell" "hm_only" ];
    apps.kitty.package = config.lib.nixGL.wrap pkgs.kitty;
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
