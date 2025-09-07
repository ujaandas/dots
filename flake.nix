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

    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, agenix }:
  let
    user = "ooj";
    configuration = { pkgs, ... }: {
      environment.systemPackages =
        [ pkgs.vim ];

      nix.settings.experimental-features = "nix-command flakes";

      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."ooj" = darwin.lib.darwinSystem {
      specialArgs = inputs // { inherit user; };
      modules = [ 
        configuration 
        agenix.nixosModules.default
        home-manager.darwinModules.home-manager
      ];
    };
  };
}
