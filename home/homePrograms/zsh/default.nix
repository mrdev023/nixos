{ config, pkgs, lib, ... }:
with lib;
{
  options.homePrograms.zsh = {
    enable = mkEnableOption ''
      Enable zsh with my custom configurations
    '';
  };
  config =
    let
      cfg = config.homePrograms.zsh;
    in
      mkIf cfg.enable {
        programs.zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;

          initExtra = ''
            [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
          '';

          plugins = with pkgs; [
            {
              file = "powerlevel10k.zsh-theme";
              name = "powerlevel10k";
              src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
            }
            {
              file = "p10k.zsh";
              name = "powerlevel10k-config";
              src = zsh-powerlevel10k;
            }
          ];
        };
      };
}