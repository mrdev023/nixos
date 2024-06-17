{ pkgs }:

with pkgs; [
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
]