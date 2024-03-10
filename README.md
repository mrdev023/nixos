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

Clean up all useless store from old profiles
```bash
sudo nix store gc --debug
```

error: cached failure of attribute 'nixosConfigurations.perso-desktop.config.system.build.toplevel'
```bash
sudo rm -fr /root/.cache/nix/
```

## If package is marked as insecure

Example:

> error: Package 'nix-2.16.2' in /nix/store/nra828scc8qs92b9pxra5csqzffb6hpl-source/pkgs/tools/package-management/nix/default.nix:229 is marked as insecure, refusing to evaluate.
>
> Known issues:
> - CVE-2024-27297

```bash
nix path-info -r /run/current-system | grep nix-2.16.2
```
Result:
> [...]
>
> /nix/store/g4ss2h40n3j37bq20x1qw5s7nl82lch5-nix-2.16.2
>
> [...]

```bash
nix-store -q --referrers /nix/store/g4ss2h40n3j37bq20x1qw5s7nl82lch5-nix-2.16.2
```
Result:
> /nix/store/g4ss2h40n3j37bq20x1qw5s7nl82lch5-nix-2.16.2
>
> /nix/store/72pfc05339izcwqhlbs8441brrdasas7-nix-2.16.2-dev
>
> /nix/store/ln2z5d5izn8icm3wx94ci13ad19lzjhr-nixd-1.2.3

nixd is not up to date and require nix 2.16.2

# Usefull links

- https://api.github.com/rate_limit
- https://hydra.nixos.org/job/nixos/trunk-combined/tested#tabs-constituents
- https://nixpk.gs/pr-tracker.html
- https://mobile.nixos.org/

# Sources

- https://github.com/ryan4yin/nix-config/tree/v0.0.2
- https://github.com/LudovicoPiero/dotfiles
- https://github.com/donovanglover/nix-config/
