#!/bin/bash

if [[ $PATH != *".local/bin"* ]]; then
  echo "Append .local/bin to PATH in ~/.bashrc"
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  echo "Reload shell"
  source ~/.bashrc
fi

echo "Installing kde-builder"
curl 'https://invent.kde.org/sdk/kde-builder/-/raw/master/scripts/initial_setup.sh?ref_type=heads' > ~/initial_setup.sh
bash ~/initial_setup.sh && rm ~/initial_setup.sh

echo "Run initial setup from kde-builder"
kde-builder --initial-setup

echo "Install missing dependencies"
sudo dnf install qt6-qttools-devel

echo "Configuration DONE"