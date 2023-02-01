# NIX syntaxe


### Declarer des variables dans un "scope"
```nix
let
  [name]=[value];
in
{
    ...
}
```

### Keyword `with`

Sans
```nix
mavar = [ pkgs.htop ];
```

Avec
```nix
mavar = with pkgs; [ htop ];
```