# Important

Cette documentation est un résumé de ce que j'ai compris sur le fonctionnement derrière NixOS.
Je suis encore en train de découvrir son fonctionnement donc si la documentation contient des erreurs merci de me les communiquer.

# Commande utiles

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

# Resource utile

- https://nixos.wiki/wiki/Overlays | Modifie ou ajoute des packets