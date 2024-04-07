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
    systems = [
      { name = "nixos-test"; system = "x86_64-linux"; }
      { name = "perso-laptop"; system = "x86_64-linux"; }
      { name = "perso-desktop"; system = "x86_64-linux"; }
    ];
  in {
    nixosConfigurations = nixpkgs.lib.foldl (c: s:
       c // {
          ${s.name} = nixpkgs.lib.nixosSystem {
            system = s.system;
            modules = [
              ./hosts/${s.name}
              home-manager.nixosModules.home-manager
              (import ./home/common-home-manager.nix { inherit inputs; })
            ];
          };
        }) {} systems;
  };
}
