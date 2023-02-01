# Important

Cette documentation est un résumé de ce que j'ai compris sur le fonctionnement derrière NixOS.
Je suis encore en train de découvrir son fonctionnement donc si la documentation contient des erreurs merci de me les communiquer.

# Lexique

- **nix-store** (/nix/store) -> Remplace l'actuelle /lib /usr/lib /bin ...

> Il permet de stocker les dépendances avec la version et hash précis. 
>
> Ex: /nix/store/zyqz4419cwq4rdl3kmsjhhia2p2yzcmm-vscode-1.74.3.drv
>
> Contient l'ensemble des infos du packet vscode version 1.74.3

- **nix-channel**

> Un peu comme les repos sous Arch comme le repo multilib, docker, ...

- [**Home-Manager**](./home_manager/HOME.md)

> Permet d'installer des paquets uniquement pour un utilisateur spécifique
> 
> Permet de gérer les dotfiles

# Commande utiles

```bash
nixos-version 
```

```bash
nix-channel [--list/remove/add] url name
```

## nixos-rebuild

Reconstruire depuis /etc/nixos/configuration.nix
```bash
nixos-rebuild switch
```

Reconstruire depuis custom/configuration.nix
```bash
nixos-rebuild switch -I custom/configuration.nix
```

Reconstruire depuis la configuration [flake](./flake/HOME.md)
```bash
nixos-rebuild switch --flake flake_path_directory#hostname
```

## nix-collect-garbage

Retire les packets, dépendances et liens symboliques non déclarés (utilisé)
```bash
nix-collect-garbage --delete-old
```

Pareil mais pour les anciennes générations
```bash
nix-collect-garbage --delete-old
```

```bash
nix-env --list-generations
nix-env --delete-generations 14d
nix-env --delete-generations 10 11 # Jour spécifique
```

Pour le store
```bash
nix-store --gc
```

Pour tout faire d'un coup.
```bash
nix-collect-garbage -d
```

# Resource utile

- https://nixos.wiki/wiki/Overlays | Modifie ou ajoute des packets
- https://github.com/MatthiasBenaets/nixos-config
