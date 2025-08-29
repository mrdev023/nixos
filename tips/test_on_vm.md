## Test on VM

### Configure VM
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

### Build

```bash
nixos-rebuild build-vm --flake .#nixos-test
```

Or without NixOS

```
nix build .#nixosConfigurations.nixos-test.config.system.build.vm
```

### Run

```bash
./result/bin/run-nixos-vm-vm
```

### To limit resources use during build

```bash
nixos-rebuild build-vm --cores 16 --max-jobs 1 --flake .#nixos-test
```

