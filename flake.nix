{
  description = "NixOS configuration of MrDev023";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
  };

  outputs = inputs@{
    nixpkgs,
    home-manager,
    agenix,
    ...
  }:
  let
    systems = [
      { name = "nixos-test"; system = "x86_64-linux"; }
      { name = "perso-laptop"; system = "x86_64-linux"; }
      { name = "perso-desktop"; system = "x86_64-linux"; }
      { name = "pro-laptop"; system = "x86_64-linux"; }
    ];
  in {
    nixosConfigurations = nixpkgs.lib.foldl (c: s:
       c // {
          ${s.name} = nixpkgs.lib.nixosSystem {
            inherit (s) system;
            modules = [
              ./hosts/${s.name}/configuration.nix
              home-manager.nixosModules.home-manager
              agenix.nixosModules.default
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = inputs;
                home-manager.users.florian = import ./hosts/${s.name}/home.nix;
              }
            ];
          };
        }) {} systems;
  };
}
