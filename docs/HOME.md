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