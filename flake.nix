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

  outputs = inputs @ {
    self,
    nixpkgs,
    darwin,
    home-manager,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    agenix,
  }: let
    username = "ooj";
    system = "aarch64-darwin";
  in {
    darwinConfigurations.${username} = darwin.lib.darwinSystem {
      specialArgs =
        inputs
        // {
          inherit username;
        };
      modules = [
        ./hosts/darwin/default.nix
        agenix.nixosModules.default
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
      ];
    };

    devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
      buildInputs = with nixpkgs.legacyPackages.${system}; [
        nixfmt-rfc-style
        nixpkgs-fmt
        statix
        alejandra
        self.packages.default.build
        self.packages.default.activate
        self.packages.default.rebuild
        self.packages.default.format
        self.packages.default.lint
      ];
    };

    packages.default = let
      pkgs = nixpkgs.legacyPackages.${system};

      mkScript = name: text:
        pkgs.writeShellApplication {
          inherit name;
          inherit text;
          runtimeInputs = with pkgs; [
            nixfmt-rfc-style
            nixpkgs-fmt
            statix
            alejandra
          ];
        };
    in {
      build = mkScript "build" ''
        echo "🔨 Building system flake..."
        sudo darwin-rebuild build --flake .#${username}
      '';

      activate = mkScript "activate" ''
        echo "🚀 Activating system from ./result..."
        sudo darwin-rebuild build activate
      '';

      format = mkScript "format" ''
        echo "🎨 Formatting Nix code..."

        case "$1" in
          --alejandra) formatter="alejandra" ;;
          --nixpkgs-fmt) formatter="nixpkgs-fmt" ;;
          --nixfmt-rfc-style) formatter="nixfmt-rfc-style" ;;
          *) formatter="nixfmt-rfc-style" ;;
        esac

        echo "Using formatter: $formatter"
        "$formatter" .
      '';

      lint = mkScript "lint" ''
        echo "🔍 Linting Nix code with statix..."
        statix check --ignore result .direnv
      '';

      rebuild = mkScript "rebuild" ''
        echo "🔁 Rebuilding system..."
        nix run .#format
        nix run .#lint
        nix run .#build
        nix run .#activate
      '';
    };
  };
}
