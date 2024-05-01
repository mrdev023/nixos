{ config, pkgs, ... }: {
  # Enable nix ld
  programs.nix-ld.enable = true;

  programs.nix-ld.package = pkgs.nix-ld-rs;

  # Sets up all the libraries to load
  programs.nix-ld.libraries = with pkgs; [
    zlib
    zstd
    stdenv.cc.cc
    curl
    openssl
    attr
    libssh
    bzip2
    libxml2
    acl
    libsodium
    util-linux
    xz
    systemd
    fuse3
    icu
    nss
    expat
  ];
}
