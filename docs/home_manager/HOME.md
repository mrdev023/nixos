# Home manager

Inutile si on utilise flakes

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