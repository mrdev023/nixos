# Installation

`<hostname>` is default to `hostname` command but it can be overwritten

Build only

```bash
nixos-rebuild build --flake .#<hostname>
```

Build and switch

```bash
nixos-rebuild switch --flake .#<hostname>
```