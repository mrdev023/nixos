#!/bin/bash

if ! grep -Fxq "source ~/.kde_bashrc" ~/.bashrc
then
  cp .kde_bashrc ~/.kde_bashrc
  echo "source ~/.kde_bashrc" > ~/.bashrc
  source ~/.bashrc
fi

echo "Installing kde-builder"
curl 'https://invent.kde.org/sdk/kde-builder/-/raw/master/scripts/initial_setup.sh?ref_type=heads' > ~/initial_setup.sh
bash ~/initial_setup.sh && rm ~/initial_setup.sh

echo "Run initial setup from kde-builder"
kde-builder --initial-setup

echo "Install missing dependencies"
sudo dnf install qt6-*-devel librsvg2-devel

echo "Configuration DONE"