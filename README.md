# Usefull commands

## Configure

```bash
nixos-rebuild switch --flake flake_path_directory#hostname
```

```bash
nix flake update --extra-experimental-features "nix-command flakes"
```

## Configure VM

Configure VM
```nix
users.users.<user>.initialPassword = "<password>";
virtualisation.vmVariant = {
  # following configuration is added only when building VM with build-vm
  virtualisation = {
    memorySize = <RAM in MiB>; # Use 8192MiB memory.
    cores = <CPU Core number>;
    # And more here https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/virtualisation/qemu-vm.nix     
  };
};
```

Build
```bash
nixos-rebuild build-vm --flake .#nixos-test
```

Run
```bash
./result/bin/run-nixos-vm-vm
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

## To limit resources use during build

```bash
nixos-rebuild build-vm --cores 16 --max-jobs 1 --flake .#nixos-test
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
