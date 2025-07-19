{ ... }:

{
  imports = [
    ./distrobox.nix
    ./docker.nix
    ./monado.nix
    ./ollama.nix
    ./openssh.nix
  ];
}