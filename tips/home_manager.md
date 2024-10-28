# Home Manager on others distros

## Install home-manager

1. Add `nixpkgs` and `home-manager` channels

```bash
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

2. Install `home-manager`

```bash
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-shell '<home-manager>' -A install
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