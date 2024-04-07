{
  description = "NixOS configuration of MrDev023";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
  };

  outputs = inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
      ...
  }:
  let
    common-modules = [
      home-manager.nixosModules.home-manager
      (import ./home/common-home-manager.nix { inherit inputs; })
    ];
  in {
    nixosConfigurations = {
      nixos-test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [ ./hosts/nixos-test ] ++ common-modules;
      };

      perso-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [ ./hosts/perso-laptop ] ++ common-modules;
      };

      perso-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [ ./hosts/perso-desktop ] ++ common-modules;
      };
    };
  };
}
