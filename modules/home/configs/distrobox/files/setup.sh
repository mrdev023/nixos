if [[ ! -f $HOME/.local/bin/kde-builder ]]; then
    echo "Running first-time KDE builder setup..."

    sudo chown "$USER:$USER" "$HOME/.config" "$HOME/.ssh" "$HOME/run.sh" "$HOME/copy_polkit.sh"
    sudo chmod u+x "$HOME/run.sh" "$HOME/copy_polkit.sh"

    curl 'https://invent.kde.org/sdk/kde-builder/-/raw/master/scripts/initial_setup.sh?ref_type=heads' \
        -o "$HOME/initial_setup.sh"
    bash "$HOME/initial_setup.sh"
    rm "$HOME/initial_setup.sh"

    kde-builder --generate-config
    kde-builder --install-distro-packages

    sed -i \
        -e 's/generate-clion-project-config: false/generate-clion-project-config: true/' \
        -e 's/generate-vscode-project-config: false/generate-vscode-project-config: true/' \
        -e 's/generate-qtcreator-project-config: false/generate-qtcreator-project-config: true/' \
        "$HOME/.config/kde-builder.yaml"
fi
