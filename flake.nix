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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
    };

    nix-citizen.url = "github:LovingMelody/nix-citizen";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    inputs@{
      flake-utils,
      home-manager,
      nixpkgs,
      stylix,
      ...
    }:
    let
      home-modules = with inputs; [
        nix-flatpak.homeManagerModules.nix-flatpak
        nvf.homeManagerModules.default
        agenix.homeManagerModules.default
        stylix.homeModules.stylix
        zen-browser.homeModules.beta
        spicetify-nix.homeManagerModules.spicetify
      ];

      overlays = with inputs; [
        nur.overlays.default
        nixgl.overlay
      ];

      extraSpecialArgs = { inherit inputs; };

      customNixosSystem =
        {
          name,
          system,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules =
            with inputs;
            [
              ./hosts/${name}/configuration.nix
              ./hosts/${name}/home.nix

              home-manager.nixosModules.home-manager
              lanzaboote.nixosModules.lanzaboote
              disko.nixosModules.disko
              agenix.nixosModules.default

              (
                { lib, pkgs, ... }:
                {
                  nixpkgs.overlays = overlays;
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.extraSpecialArgs = extraSpecialArgs;
                  home-manager.sharedModules = home-modules ++ [
                    # Disable overlays for NixOS
                    { stylix.overlays.enable = false; }
                  ];
                  home-manager.backupCommand = lib.getExe pkgs.trash-cli;
                }
              )
            ]
            ++ extraModules;
        };

      customHomeManagerConfiguration =
        {
          name,
          system,
        }:
        home-manager.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgs {
            inherit overlays system;
          };

          modules = home-modules ++ [
            { nix.package = pkgs.nix; }
            ./hosts/${name}/home.nix
          ];

          extraSpecialArgs = extraSpecialArgs;
        };
    in
    {
      #####################################################################
      #####################################################################
      # Configure all nixos configurations
      #####################################################################
      #####################################################################
      nixosConfigurations = {
        nixos-desktop-perso = customNixosSystem {
          name = "perso-desktop";
          system = "x86_64-linux";
        };
        nixos-laptop-perso = customNixosSystem {
          name = "perso-laptop";
          system = "x86_64-linux";
        };
        nixos-laptop-pro = customNixosSystem {
          name = "pro-laptop";
          system = "x86_64-linux";
        };
        nixos-test-perso = customNixosSystem {
          name = "nixos-test";
          system = "x86_64-linux";
        };
      };

      #####################################################################
      #####################################################################
      # Configure home configuration for all others systems like Arch Linux
      #####################################################################
      #####################################################################
      homeConfigurations = {
        "florian@archlinux" = customHomeManagerConfiguration {
          name = "kdedev-home";
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
    // flake-utils.lib.eachSystem flake-utils.lib.allSystems (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        agenix = inputs.agenix.packages.${system}.default;
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nixd
              nil
              agenix
            ];
          };
        };
        formatter = pkgs.nixfmt-tree;
      }
    );
}
