# How to develop on KDE

## First configuration

1. `distrobox assemble`
    > You can add --replace to recreate distrobox container
2. `distrobox enter kdedev`
3. `bash configure.sh`
4. `kde-builder run solid`

## Usefull config in ~/.config/kdesrc-buildrc

Autogenerate editor configuration

- generate-clion-project-config
- generate-vscode-project-config
- generate-qtcreator-project-config