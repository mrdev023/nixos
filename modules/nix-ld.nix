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

    # For UE5
    glibc
    libdrm
    libgcc
    vulkan-loader
    vulkan-tools
    vulkan-extension-layer
    vulkan-validation-layers
    SDL2.dev
    libGL
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXau
    xorg.libXcursor
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXxf86vm
    xorg.libxcb
    python311
  ];
}
