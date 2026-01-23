{
  config,
  pkgs,
  lib,
  ...
}:

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

      initContent = lib.mkOrder 1200 ''
        [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
        # Enable Emacs-style line editing
        bindkey -e
        # Use terminfo for Alt+Left/Right navigation (Emacs mode)  
        if [[ -n "$terminfo[kLFT5]" ]]; then  
          bindkey "$terminfo[kLFT5]" backward-word   # Alt+Left  
        fi  
        if [[ -n "$terminfo[kRIT5]" ]]; then  
          bindkey "$terminfo[kRIT5]" forward-word    # Alt+Right  
        fi
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
