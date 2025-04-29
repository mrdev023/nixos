{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.home.shell.zsh;
in
{
  options.modules.home.shell.zsh = {
    enable = mkEnableOption ''
      Enable zsh with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initContent = ''
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