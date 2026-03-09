{
  config,
  ...
}:

with config.lib.stylix.colors;
{
  programs.hyprlock = {
    enable = true;

    settings = {
      background = {
        blur_passes = 3;
        blur_size = 7;
        brightness = 0.6;
      };

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
          font_size = 90;
          color = "rgba(${base05}, ff)";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%A %d %B")"'';
          font_size = 24;
          color = "rgba(${base05}, ff)";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
