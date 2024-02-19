{
  description = "NixOS configuration of MrDev023";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
  }: {
    nixosConfigurations = {
      nixos-test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/nixos-test

          home-manager.nixosModules.home-manager
          (import ./home/common-home-manager.nix { inherit inputs; })
        ];
      };

      perso-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/perso-laptop

          home-manager.nixosModules.home-manager
          (import ./home/common-home-manager.nix { inherit inputs; })
        ];
      };

      perso-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/perso-desktop

          home-manager.nixosModules.home-manager
          (import ./home/common-home-manager.nix { inherit inputs; })
        ];
      };
    };
  };
}
