{ ... }:
{
  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };
  };

  # Configure console keymap
  console.keyMap = "us";
}
