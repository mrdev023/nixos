# Home Manager on others distros

## Install home-manager

1. Edit /etc/nix/nix.conf

```
experimental-features = nix-command flakes
```

2. Apply the configuration for the first time

```
nix run nixpkgs#home-manager -- switch --flake .#hostname // First time
home-manager -- switch --flake .#hostname // Then
```

## How use home-manager

1. Switch

```bash
home-manager switch --flake .#perso-home
```

2. List generations

```bash
home-manager generations
```
