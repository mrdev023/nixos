# Fonctionnement de flake

### Général

- Permet de télécharger des dépendances de code comme \<home-manager>
> Stocke les dépendances dans le fichier `flake.lock`.
> Si l'on souhaite figer la version des dépendances pour éviter tout risque de mauvaise configuration. On peut utiliser le fichier `flake.log`

- Permet de configurer facilement notre propre configuration comme depuis les dotfiles

### Installation

Pour le moment, flake est encore expérimental donc il faut l'activer manuellement.

/etc/nixos/configuration.nix
```nix
[...]
  # BEGIN: Add flake feature TODO: Remove when not experimental
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
  # END: Add flake feature
}
```

### Configuration initial

Génére le fichier `flake.nix`
```bash
nix flake init
```

`flake.nix`
```nix
{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
```

### Structure

#### Inputs

Défini l'ensemble des dépendances utilisées dans le `flake`

```nix
inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
};
```

#### Outputs

Récupère les inputs dans la fonction en paramètre
- Permet de configurer ce que l'on a importé.
- Peut configurer les packages, configurations, modules, ...

```nix
outputs = { self, nixpkgs }:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
        lib = nixpkgs.lib;
    in {
        nixosConfigurations = {
            # <hostname or user> specified with
            # `nixos-rebuild [build/switch] --flake .#<hostname or user>`
            <hostname or user> = lib.nixosSystem {
                inherit system;
                modules = [ ./configuration.nix ];
            };
        };
    };
```

### Installation

`<hostname or user>` is default to `hostname or user` command but it can be overwritten

Build only

```bash
nixos-rebuild build --flake .#<hostname or user>
```

Build and switch

```bash
nixos-rebuild switch --flake .#<hostname or user>
```

Build script to activate in current shell
```bash
nix build .#hmConfig.<hostname or user>.activationPackage
```
with
```bash
./result/activate
```

### Updating

```bash
nix flake update #--recreate-lock-file
```

### Flake sur une installation vierge

Démarrage depuis l'ISO

```bash
sudo su
nix-env -iA nixos.git
git clone <repo url> /mnt/<path>
nixos-install --flake .#<host>
reboot
/* login */
# Car parfois, nixos peut compiler la version par défaut
sudo rm -r /etc/nixos/configuration.nix
/* move build to desired location */
```