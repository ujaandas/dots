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

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      home-manager,
      nix-homebrew,
      homebrew-bundle,
      homebrew-core,
      homebrew-cask,
      nix-vscode-extensions,
      agenix,
    }:
    let
      username = "ooj";
      # todo: either use flake-utils or make helper funcs
      system = "aarch64-darwin";
    in
    {
      darwinConfigurations.${username} = darwin.lib.darwinSystem {
        specialArgs = inputs // {
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
        buildInputs = [
          self.packages.${system}.build
          self.packages.${system}.activate
          self.packages.${system}.rebuild
          self.packages.${system}.format
          self.packages.${system}.lint
          self.packages.${system}.test-all
          self.packages.${system}.check
        ];
      };

      packages.${system} =
        let
          pkgs = nixpkgs.legacyPackages.${system};

          mkScript =
            name: text:
            pkgs.writeShellApplication {
              inherit name;
              inherit text;
              runtimeInputs = with pkgs; [
                nixfmt-tree
                statix
              ];
            };
        in
        {
          build = mkScript "build" ''
            echo "Building system flake..."
            if sudo darwin-rebuild build --flake .#${username}; then
              echo "Build completed successfully."
            else
              echo "Build failed."
              exit 1
            fi
          '';

          activate = mkScript "activate" ''
            echo "Activating system..."
            if sudo result/activate; then
              echo "Activation completed successfully."
            else
              echo "Activation failed."
              exit 1
            fi
          '';

          format = mkScript "format" ''
            echo "Formatting Nix code..."
            if treefmt --walk git; then
              echo "Formatting completed successfully."
            else
              echo "Formatting failed."
              exit 1
            fi
          '';

          lint = mkScript "lint" ''
            echo "Linting Nix code..."
            if statix check --ignore result .direnv; then
              echo "Linting passed with no issues."
            else
              echo "Linting failed: issues detected."
              exit 1
            fi
          '';

          check = mkScript "check" ''
            echo "Checking flake..."
            if nix flake check; then
              echo "Flake check passed with no issues."
            else
              echo "Flake check failed: issues detected."
              exit 1
            fi
          '';

          test-all = mkScript "test-all" ''
            echo "Testing system..."
            check || exit 1
            format || exit 1
            lint || exit 1
            build || exit 1
            echo "Test completed successfully."
          '';

          rebuild = mkScript "rebuild" ''
            echo "Rebuilding system..."
            test-all || exit 1
            activate || exit 1
            echo "Rebuild completed successfully."
          '';
        };
    };
}
