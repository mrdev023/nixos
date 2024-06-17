{ pkgs }:

with pkgs; [
  # From https://invent.kde.org/sysadmin/repo-metadata/-/blob/6ddda1e450fdbc093ca0138cf1c850e7b7e75044/distro-dependencies/arch.ini

  # .. gnu
  autoconf
  automake
  bison
  flex
  gcc
  gperf
  gnumake
  texinfo

  # .. llvm
  clang
  cmake

  # .. build systems
  meson
  ninja

  # .. rust
  corrosion

  # .. others
  boost
  docbook_xsl
  doxygen
  gi-docgen
  git
  intltool
  pkg-config

  # Qt-related
  kdePackages.accounts-qt

  libdbusmenu
  packagekit
  kdePackages.qtbase
  kdePackages.qttools
  kdePackages.qtdeclarative
  kdePackages.phonon
  kdePackages.poppler
  kdePackages.qca
  kdePackages.qcoro
  kdePackages.qtkeychain

  # Others/Unsorted
  black-hole-solver
  check
  eigen
  enchant
  exiv2
  flatpak
  fluidsynth
  freecell-solver
  giflib
  itstool
  jasper
  kdePackages.kdsoap # QT6
  libcanberra
  libdisplay-info
  libdmtx
  libfakekey
  libgit2
  libical
  olm
  libpwquality
  libqalculate
  libraw
  libutempter
  xorg.libxcvt
  expat
  libxml2
  xorg.libX11 xorg.libXext xorg.libXft xorg.libXpm xorg.libXrandr xorg.libXScrnSaver # Replacement of libxss ?
  lmdb
  microsoft-gsl
  mlt
  mpv
  networkmanager
  openal
  openexr
  plymouth
  power-profiles-daemon
  kdePackages.qgpgme # qt6
  qrencode
  #     ruby-sass
  #     ruby-test-unit
  #     sane
  sccache
  shared-mime-info
  kdePackages.signond
  udisks2
  upower
  vala
  vlc
  wayland
  wayland-protocols
  wayland-scanner
  xapian
  xercesc
  xorg.xf86inputlibinput
  xf86_input_wacom
  xmlto
  xorg.xorgserver
  xsd
  zxing-cpp
  gtk3

  # plasma-desktop
  xdotool

  # appstream
  gobject-introspection
  xorg.xf86inputevdev

  # okular
  discount
  djvulibre
  ebook_tools
  libspectre
  libzip

  (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
    pycairo
    pip
    setuptools
    sphinx

    # drkonqi
    psutil
    pygdbmi
    sentry-sdk
  ]))

  # kpipewire
  pipewire
]