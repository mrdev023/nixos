{ lib, options, ... }:

with lib;
{
  config = optionalAttrs (options ? stylix) {
    stylix.targets.obsidian.vaultNames = [ "perso_obsidian_vault" ];
  };
}
