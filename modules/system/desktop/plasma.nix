{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.system.desktop.plasma;
  nixpkgsPr = builtins.fetchTarball {
    url = "https://github.com/Sicheng-Pan/nixpkgs/archive/5ba93319d81da028339755243fa405556a2b18d7.tar.gz";
    sha256 = "0xiighffwyhis6ni815s6bqcrvhsr3s7c208sq3c4y5p2f1g397w";
  };
in
{
  options.modules.system.desktop.plasma = {
    enable = mkEnableOption ''
      Enable plasma with my custom configurations
    '';

    enableWallpaperEngine = mkEnableOption ''
      Enable wallpaper engine plugin for plasma
    '';

    enableSddm = mkOption {
      type = types.bool;
      description = "Enable sddm with custom plasma";
      default = true;
    };
  };
  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = cfg.enableSddm;
    services.desktopManager.plasma6.enable = true;

    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; with kdePackages; [
      krfb # Use by kdeconnect for virtualmonitorplugin "krfb-virtualmonitor"
      discover
      kgpg
      yakuake
    ] ++ lib.optionals cfg.enableWallpaperEngine [
      ### wallpaper-engine-plugin
      (callPackage "${nixpkgsPr}/pkgs/kde/third-party/wallpaper-engine-plugin/default.nix" {})
      qtmultimedia
      qtwebchannel
      qtwebengine
      qtwebsockets
      (python3.withPackages (python-pkgs: [ python-pkgs.websockets ]))
      ###
    ];
  };
}
