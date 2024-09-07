# How to develop on KDE

## First configuration

1. `distrobox assemble`
   > You can add --replace to recreate distrobox container
2. `distrobox enter kdedev`
3. `bash configure.sh`
4. `kde-builder run solid`
   > You use NixOS ? It's necessary to run `new_shell` alias before.
   > The alias unset all nixos env variables with nix store references to avoid conflicts with build or run of KDE Shells/Apps/Tools.

## Usefull config in ~/.config/kdesrc-buildrc

Autogenerate editor configuration

- generate-clion-project-config
- generate-vscode-project-config
- generate-qtcreator-project-config
