{
  config,
  ...
}:

let
  # Stylix
  colors = config.lib.stylix.colors.withHashtag;
  fonts = config.stylix.fonts;

  # Custom
  variables = import ../../variables.nix;
  border.radius = toString variables.window.border.radius;
  window.gap = toString variables.window.gap;
  entry.gap = {
    x = toString variables.window.gap;
    y = toString (variables.window.gap / 2);
  };
in
{
  stylix.targets.wofi.enable = false;
  programs.wofi = {
    enable = true;

    settings = {
      close_on_focus_loss = true;

      key_up = "Ctrl-k";
      key_down = "Ctrl-j";
      key_left = "Ctrl-h";
      key_right = "Ctrl-l";
      key_pgup = "Ctrl-b";
      key_pgdn = "Ctrl-f";
    };

    # Inspired by stylix https://github.com/nix-community/stylix/blob/c4b8e80a1020e09a1f081ad0f98ce804a6e85acf/modules/wofi/hm.nix
    style = ''
      window {
        font-family: "${fonts.monospace.name}";
        font-size: ${toString fonts.sizes.popups}pt;
        background-color: ${colors.base00};
        color: ${colors.base05};
        border-radius: ${border.radius}px;
      }

      #outer-box {
        padding: ${window.gap}px;
      }

      #entry {
        padding: ${entry.gap.x}px ${entry.gap.y}px;
        background-color: ${colors.base00};
        border-radius: ${border.radius}px;
      }

      #entry:selected {
        background-color: ${colors.base02};
      }

      #input {
        background-color: ${colors.base01};
        color: ${colors.base04};
        border-color: ${colors.base02};
        border-radius: ${border.radius}px;
        margin-bottom: ${window.gap}px;
      }

      #input:focus {
        border-color: ${colors.base0A};
      }
    '';
  };
}
