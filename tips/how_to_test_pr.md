# Example for ollama

```nix
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.system.server.ollama;
  nvidiaEnabled = config.modules.system.hardware.nvidia.enable;
  nixpkgsPr = builtins.fetchTarball {
    url = "https://github.com/abysssol/nixpkgs/archive/ollama-driver-runpath.tar.gz";
    sha256 = "1ixfvdpi2v4r9yrkvqnfk9whs8lyjhrkdph47bcznh8ak9aipr8p";
  };
in
{
  disabledModules = [ "services/misc/ollama.nix" ];
  imports = [
    (import "${nixpkgsPr}/nixos/modules/services/misc/ollama.nix")
  ];

  options.modules.system.server.ollama = {
    enable = mkEnableOption ''
      Enable ollama with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;

      package = (import nixpkgsPr { inherit (pkgs) system; config.allowUnfree = true; }).ollama;

      acceleration = if nvidiaEnabled then "cuda" else null;
    };
  };
}
```
