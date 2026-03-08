{ ... }:

{
  config.services.flatpak = {
    update.onActivation = true;

    packages = [
      # Pro
      {
        appId = "ch.protonmail.protonmail-bridge";
        origin = "flathub";
      }
      {
        appId = "org.kde.neochat";
        origin = "flathub";
      }

      # Loisir
      {
        appId = "org.videolan.VLC";
        origin = "flathub";
      }
    ];
  };
}
