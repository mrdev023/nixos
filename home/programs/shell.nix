{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = ''
      [[ ! -f ${../files/p10k.zsh} ]] || source ${../files/p10k.zsh}
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

  home.packages = with pkgs; [
    fira-code-nerdfont
  ];

}
