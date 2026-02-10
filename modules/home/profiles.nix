{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home;
in
{
  options.modules.home = {
    profiles = mkOption {
      type = types.listOf (
        types.enum [
          "hm_only"
          "shell"
        ]
      );
      default = [ ];
      example = [ "shell" ];
      description = "Enable pre-defined profile.";
    };
  };
  config = mkMerge [
    # Install all default tools to work only from shell
    (mkIf (elem "shell" cfg.profiles) {
      modules.home = {
        apps.kitty.enable = true;

        shell = {
          atuin.enable = true;
          difftastic.enable = true;
          direnv.enable = true;
          git.enable = true;
          jujutsu.enable = true;
          lazygit.enable = true;
          mergiraf.enable = true;
          television = {
            enable = true;
            channels = [ "nix-search-tv" ];
          };
          superfile.enable = true;
          zsh.enable = true;
          zoxide.enable = true;
        };

        editors.helix.enable = true;
      };

      programs.helix.defaultEditor = true;
    })

    # Profile for minimal usable home manager configuration on non NixOS
    (mkIf (elem "hm_only" cfg.profiles) {
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

      # Enable only for non NixOS homes
      # Already enabled for NixOS in modules/system/common.nix
      programs.nh = {
        enable = true;

        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 3";
        };
      };
    })
  ];
}
