# Home manager

## Installation

*sudo si l'on souhaite utiliser le module NixOS depuis /etc/nixos/configuration.nix*
```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
```
or
```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/release-${NIX_VERSION}.tar.gz home-manager
```

```bash
nix-channel --update
```

Relancer la session pour reload les channels pour le user courant.

**La version root non requis si on utilise flakes et nix-shell**

```bash
nix-shell '<home-manager>' -A install
```

$HOME/.config/nixpkgs/home.nix

```nix
{
...

  home.packages = with pkgs; [ htop ];

  services.dunst = {
    enable = true;
  };

  home.file = {
    ".config/alacritty/alacritty.yml".text = ''
        {"font":{"bold":{"style":"Bold"}}}
    '';
  };

  home.file.".doom.d" = {
    source = ./doom.d;
    recursive = true;
    onChange = builtins.readFile ./doom.sh;
  };

  home.file.".config/polybar/script/mic.sh" = {
    source = ./mic.sh;
    executable = true;
  };
}
```

Cette exemple va générer le fichier *.config/bspwm/bspwmrc*
```nix
{
    xsession = {
        windowManager = {
            bspwm = {
                enable = true;
                rules = {
                    "Emacs" = {
                        desktop = "3";
                        follow = true;
                        state = "tiled";
                    };
                    ".blueman-manager-wrapped" = {
                        state = "floating";
                        sticky = true;
                    };
                };
            };
        };
    };
}
```

Mettre à jour les modifications

```bash
home-manager switch
```

```bash
man home-configuration.nix
```