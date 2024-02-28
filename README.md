
# Usefull commands

## Configure

```bash
nixos-rebuild switch --flake flake_path_directory#hostname
```

```bash
nix flake update --extra-experimental-features "nix-command flakes"
```

## Clean system

List all profiles
```bash
nix profile history --profile /nix/var/nix/profiles/system
```

Remove all profiles older than 7 days
```bash
sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system
```

Clean up all useless store from old profiles
```bash
sudo nix store gc --debug
```

# Usefull links

- https://api.github.com/rate_limit
- https://hydra.nixos.org/job/nixos/trunk-combined/tested#tabs-constituents
- https://nixpk.gs/pr-tracker.html
- https://mobile.nixos.org/

# Sources

- https://github.com/ryan4yin/nix-config/tree/v0.0.2
- https://github.com/LudovicoPiero/dotfiles
- https://github.com/donovanglover/nix-config/
