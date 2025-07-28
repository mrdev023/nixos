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

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

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
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-utils,
    home-manager,
    nixpkgs,
    ...
  }: let
    home-modules = with inputs; [
      nix-flatpak.homeManagerModules.nix-flatpak
      nix-doom-emacs.hmModule
      nvf.homeManagerModules.default
      sops-nix.homeManagerModules.sops
    ];

    overlays = with inputs; [
      nur.overlays.default
      nixgl.overlay
    ];

    customNixosSystem = {
      name,
      system,
      extraModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          with inputs; [
            ./hosts/${name}/configuration.nix
            ./hosts/${name}/home.nix

            home-manager.nixosModules.home-manager
            lanzaboote.nixosModules.lanzaboote
            disko.nixosModules.disko
            chaotic.nixosModules.default
            sops-nix.nixosModules.sops

            {
              nixpkgs.overlays = overlays;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = inputs;
              home-manager.sharedModules = home-modules;
            }
          ] ++ extraModules;
      };

    customHomeManagerConfiguration = {
      name,
      system,
    }:
      home-manager.lib.homeManagerConfiguration rec {
        pkgs = import nixpkgs {
          inherit overlays system;
        };

        modules =
          home-modules
          ++ [
            {nix.package = pkgs.nix;}
            ./hosts/${name}/home.nix
          ];

        extraSpecialArgs = inputs;
      };
  in
    {
      #####################################################################
      #####################################################################
      # Configure all nixos configurations
      #####################################################################
      #####################################################################
      nixosConfigurations = {
        homeserver = customNixosSystem {
          name = "homeserver";
          system = "x86_64-linux";
        };
        perso-laptop = customNixosSystem {
          name = "perso-laptop";
          system = "x86_64-linux";
        };
        perso-desktop = customNixosSystem {
          name = "perso-desktop";
          system = "x86_64-linux";
        };
      };

      #####################################################################
      #####################################################################
      # Configure home configuration for all others systems like Arch Linux
      #####################################################################
      #####################################################################
      homeConfigurations = {
        pro-home = customHomeManagerConfiguration {
          name = "pro-home";
          system = "x86_64-linux";
        };
      };
    }
    #####################################################################
    #####################################################################
    # Configure development shell for all systems and merge with all
    # previous configurations with //
    #####################################################################
    #####################################################################
    // flake-utils.lib.eachSystem flake-utils.lib.allSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nixd
            sops
          ];
        };
      };
    });
}
