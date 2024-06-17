{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.system.hardware.nix-ld;
in
{
  options.modules.system.hardware.nix-ld = {
    enable = mkEnableOption ''
      Enable nixLd with my custom configurations
    '';

    enableKdeDevelopmentEnvironment = mkEnableOption ''
      Configure all required packages to develop with kde-builder
    '';
  };
  config = mkIf cfg.enable {
    # Enable nix ld
    programs.nix-ld.enable = true;

    programs.nix-ld.package = pkgs.nix-ld-rs;

    programs.nix-ld.libraries = [
      # Empty for now but used for default packages
    ] ++ lib.optionals cfg.enableKdeDevelopmentEnvironment (import ./kde-dev-packages.nix { inherit pkgs; });
  } // mkIf cfg.enableKdeDevelopmentEnvironment {
    environment.systemPackages = [
      (import ../../../../pkgs/kde-builder.nix { inherit pkgs; })
    ];
  };
}