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
