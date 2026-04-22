{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.programs.distrobox;
  username = config.home.username;
  homeDir = config.home.homeDirectory;
  configDir = config.xdg.configHome;
  flakeDir = config.home.sessionVariables.NH_FLAKE or "${homeDir}/nixos";

  initHookScript = pkgs.writeShellScript "kdedev-init-hook" ''
    set -euo pipefail

    rm -f /usr/bin/flatpak

    mkdir -p /usr/share/polkit-1/rules.d
    cat > /usr/share/polkit-1/rules.d/49-allow-kde.rules << 'POLKIT'
    polkit.addRule(function(action, subject) {
        if (action.id.startsWith("org.kde.") && subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
    POLKIT

    sed -i 's/#IdleAction=ignore/IdleAction=ignore/' /etc/systemd/logind.conf

    sudo -u ${username} \
      NIXPKGS_ALLOW_UNFREE=1 \
      NIX_CONFIG="extra-experimental-features = nix-command flakes" \
      nix shell "nixpkgs#home-manager" -c home-manager switch \
        --flake "${flakeDir}#florian@kdedev" \
        --impure
  '';
in
{
  options.modules.home.programs.distrobox = {
    enable = mkEnableOption "distrobox kdedev container definition";
  };

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.distrobox.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          substituteInPlace $out/bin/distrobox-enter \
            --replace-fail 'set -- "--pty" "$@"' ':'
        '';
      }))
    ];

    xdg.configFile."distrobox/kdedev_init_hook.sh" = {
      executable = true;
      source = initHookScript;
    };

    xdg.configFile."distrobox/distrobox.conf".text = ''
      ${getExe pkgs.xhost} +si:localuser:${username} > /dev/null 2>&1 || true
    '';

    xdg.configFile."distrobox/kdedev.ini".text = ''
      [kdedev]
      home=${homeDir}/distrobox/kdedev
      init_hooks="${configDir}/distrobox/kdedev_init_hook.sh"
      additional_packages="kde-cli-tools base-devel nix"
      image=docker.io/archlinux:latest
      init=true
      nvidia=true
      pull=true
      root=false
    '';
  };
}
