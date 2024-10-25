# Usefull commands

## Configure

```bash
nixos-rebuild switch --flake flake_path_directory#hostname
```

```bash
nix flake update --extra-experimental-features "nix-command flakes"
```

## Show changements between revisions


```bash
nix profile diff-closures --profile /nix/var/nix/profiles/system
```

```bash
nix store diff-closures /nix/var/nix/profiles/system-rev1-link /nix/var/nix/profiles/system-rev2-link
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

```bash
nix profile wipe-history --older-than 7d --profile ~/.local/state/nix/profiles/home-manager
```

Clean up all useless store from old profiles
```bash
sudo nix store gc --debug
```

error: cached failure of attribute 'nixosConfigurations.perso-desktop.config.system.build.toplevel'
```bash
sudo rm -fr /root/.cache/nix/
```


## To limit resources use during build

```bash
nixos-rebuild build-vm --cores 16 --max-jobs 1 --flake .#nixos-test
```

Or without NixOS

```
nix build .#nixosConfigurations.nixos-test.config.system.build.vm
```

# Usefull links

- https://api.github.com/rate_limit
- https://hydra.nixos.org/job/nixos/trunk-combined/tested#tabs-constituents
- https://nixpk.gs/pr-tracker.html
- https://mobile.nixos.org/
- https://nixos.wiki/wiki/Build_flags

# Sources

- https://github.com/ryan4yin/nix-config/tree/v0.0.2
- https://github.com/LudovicoPiero/dotfiles
- https://github.com/donovanglover/nix-config/
