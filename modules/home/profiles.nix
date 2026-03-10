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
      programs = {
        atuin.enable = true;
        difftastic.enable = true;
        direnv.enable = true;
        kitty.enable = true;
        helix = {
          enable = true;
          defaultEditor = true;
        };
        lazygit.enable = true;
        mergiraf.enable = true;
        git.enable = true;
        jujutsu.enable = true;
        superfile.enable = true;
        zoxide.enable = true;
        zsh.enable = true;
      };

      home = {
        file.".ssh/import-agent-keys.sh" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash
            mkdir -p ~/.ssh
            rm ~/.ssh/*_ssh.pub
            ssh-add -L | while read -r type key comment; do
              filename=$(echo "$comment" | tr ' ' '_' | tr '[:upper:]' '[:lower:]').pub
              echo "$type $key $comment" > ~/.ssh/"$filename"
              echo "Imported: ~/.ssh/$filename"
            done
          '';
        };

        packages = with pkgs; [
          tldr # Alternative à man
          claude-code
          npins
        ];

        sessionVariables = {
          SSH_AUTH_SOCK = "${config.home.homeDirectory}/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock";
        };

        shellAliases = {
          help = "tldr";
        };
      };
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
