{
  description = "NixOS configuration of MrDev023";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

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

    # Follow nix-doom-emacs completely when this is merged or fixed
    # - https://github.com/nix-community/nix-doom-emacs/issues/409
    # - https://github.com/nix-community/nix-straight.el/pull/4
    nix-straight = {
      url = "github:codingkoi/nix-straight.el?ref=codingkoi/apply-librephoenixs-fix";
      flake = false;
    };
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs = {
        nix-straight.follows = "nix-straight";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs@{
    nixpkgs,
    nur,
    home-manager,
    agenix,
    nix-flatpak,
    nix-doom-emacs,
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
              { nixpkgs.overlays = [ nur.overlay ]; }
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = inputs;
                home-manager.users.florian.imports = [
                  nix-flatpak.homeManagerModules.nix-flatpak
                  nix-doom-emacs.hmModule
                  
                  ./hosts/${s.name}/home.nix
                ];
              }
            ];
          };
        }) {} systems;
  };
}
