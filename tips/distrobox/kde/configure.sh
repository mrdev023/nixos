#!/bin/bash

if [[ $PATH != *".local/bin"* ]]; then
  echo "Append .local/bin to PATH in ~/.bashrc"
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  echo "Reload shell"
  source ~/.bashrc
fi

if [[ $PATH != *"alias new_shell"* ]]; then
  echo "Append new_shell alias to PATH in ~/.bashrc"
  echo 'alias new_shell="env -u PATH -u QML2_IMPORT_PATH -u QT_PLUGIN_PATH -u NIXPKGS_QT6_QML_IMPORT_PATH -u XDG_CONFIG_DIRS bash -l"' >> ~/.bashrc
  echo "Reload shell"
  source ~/.bashrc
fi

echo "Installing kde-builder"
curl 'https://invent.kde.org/sdk/kde-builder/-/raw/master/scripts/initial_setup.sh?ref_type=heads' > ~/initial_setup.sh
bash ~/initial_setup.sh && rm ~/initial_setup.sh

echo "Run initial setup from kde-builder"
kde-builder --initial-setup

echo "Install missing dependencies"
sudo dnf install qt6-*-devel

echo "Configuration DONE"