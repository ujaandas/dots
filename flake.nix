{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, agenix }:
  let
    username = "ooj";
  in
  {
    darwinConfigurations.${username} = darwin.lib.darwinSystem {
      specialArgs = inputs // { inherit username; };
      modules = [ 
        ./hosts/darwin/default.nix
        agenix.nixosModules.default
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
      ];
    };
  };
}
