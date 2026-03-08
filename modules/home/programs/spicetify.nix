{
  inputs,
  pkgs,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  config.programs.spicetify = {
    enabledExtensions = with spicePkgs.extensions; [
      keyboardShortcut
    ];
  };
}
