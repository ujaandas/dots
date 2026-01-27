{
  description = "Example nix-darwin + nixos flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

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
      wsl,
      home-manager,
      nix-homebrew,
      agenix,
      ...
    }:
    let
      username = "ooj";

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

<<<<<<< HEAD
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
=======
      forSystems =
        f:
        builtins.listToAttrs (
          map (system: {
            name = system;
            value = f system;
          }) systems
        );
>>>>>>> 1361dd629cf781006b31c50f4d2b3c59166f8dbd

      mkScripts =
        pkgs:
        let
          mkScript =
            name: text:
            pkgs.writeShellApplication {
              inherit name text;
              runtimeInputs = with pkgs; [
                nixfmt-tree
                statix
              ];
            };
        in
        {
<<<<<<< HEAD
          build = mkScript "build" ''
            echo "Building system flake..."
            if sudo darwin-rebuild build --flake .#${username}; then
              echo "Build completed successfully."
            else
              echo "Build failed."
              exit 1
            fi
=======
          search = mkScript "search" ''nix repl -f '<nixpkgs>' '';
          build = mkScript "build" ''
            case "$(uname)" in
              Darwin) sudo darwin-rebuild build --flake .#${username} ;;
              Linux)  sudo nixos-rebuild build --flake .#${username} ;;
            esac
>>>>>>> 1361dd629cf781006b31c50f4d2b3c59166f8dbd
          '';
          activate = mkScript "activate" ''
<<<<<<< HEAD
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
=======
            if [[ -e result/activate ]]; then sudo result/activate; fi
>>>>>>> 1361dd629cf781006b31c50f4d2b3c59166f8dbd
          '';
          format = mkScript "format" ''treefmt --walk git'';
          lint = mkScript "lint" ''statix check --ignore result .direnv'';
          check = mkScript "check" ''nix flake check'';
          test-all = mkScript "test-all" ''check && format && lint && build'';
          rebuild = mkScript "rebuild" ''test-all && activate'';
        };
    in
    {
      # OS-specific configs
      nixosConfigurations.${username} = nixpkgs.lib.nixosSystem {
        specialArgs = inputs // {
          inherit username;
          isCli = true;
        };
        modules = [
          ./hosts/wsl
          wsl.nixosModules.default
          home-manager.nixosModules.home-manager
        ];
      };

      darwinConfigurations.${username} = darwin.lib.darwinSystem {
        specialArgs = inputs // {
          inherit username;
          isCli = false;
        };
        modules = [
          ./hosts/darwin
          agenix.nixosModules.default
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };

      packages = forSystems (
        system:
        let
          scripts = mkScripts nixpkgs.legacyPackages.${system};
        in
        scripts
        // {
          default = nixpkgs.legacyPackages.${system}.symlinkJoin {
            name = "scripts";
            paths = builtins.attrValues scripts;
          };
        }
      );

      devShells = forSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          buildInputs = builtins.attrValues self.packages.${system};
        };
      });

    };
}
