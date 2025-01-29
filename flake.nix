{
  description = "NixOS configuration of MrDev023";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Use to clean dependencies
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
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
      inputs.nix-straight.follows = "nix-straight";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # To use nixos program on others distros
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    nixpkgs,
    flake-utils,
    home-manager,
    agenix,
    lanzaboote,
    disko,
    ...
  }:
  let
    systems = [
      { name = "nixos-test"; system = "x86_64-linux"; }
      { name = "perso-laptop"; system = "x86_64-linux"; }
      { name = "perso-desktop"; system = "x86_64-linux"; }
    ];

    home-modules = with inputs; [
      nix-flatpak.homeManagerModules.nix-flatpak
      nix-doom-emacs.hmModule
    ];

    overlays = with inputs; [
      nur.overlays.default
      nixgl.overlay
    ];
  in {
    #####################################################################
    #####################################################################
    # Configure all nixos configurations
    #####################################################################
    #####################################################################
    nixosConfigurations = nixpkgs.lib.foldl (c: s:
       c // {
          ${s.name} = nixpkgs.lib.nixosSystem {
            inherit (s) system;
            modules = [
              ./hosts/${s.name}/configuration.nix
              home-manager.nixosModules.home-manager
              agenix.nixosModules.default
              lanzaboote.nixosModules.lanzaboote
              disko.nixosModules.disko
              { nixpkgs.overlays = overlays; }
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = inputs;
                home-manager.users.florian.imports = home-modules ++ [
                  ./hosts/${s.name}/home.nix
                ];
              }
            ];
          };
        }) {} systems;

    #####################################################################
    #####################################################################
    # Configure home configuration for all others systems like Arch Linux
    #####################################################################
    #####################################################################
    homeConfigurations = {
      perso-home = home-manager.lib.homeManagerConfiguration rec {
        pkgs = import nixpkgs { system = "x86_64-linux"; inherit overlays; };

        modules = home-modules ++ [ 
          { nix.package = pkgs.nix; }
          ./hosts/perso-home/home.nix
        ];
      };
    };
  }

  #####################################################################
  #####################################################################
  # Configure development shell for all systems and merge with all
  # previous configurations with //
  #####################################################################
  #####################################################################
  // flake-utils.lib.eachSystem flake-utils.lib.allSystems (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nixd
          ];
        };
      };
    });
}
