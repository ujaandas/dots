{
  config,
  lib,
  pkgs,
  username,
  nix-vscode-extensions,
  ...
}:
let
  cfg = config.features;
in
{
  imports = [
    ./kitty.nix
    ./tmux.nix
    ./vim.nix
    ./vscode.nix
    ./zsh.nix
  ];

  options.features = {
    getStdCliPkgs = lib.mkEnableOption "Enable standard helpful CLI packages.";
    getStdGuiPkgs = lib.mkEnableOption "Enable standard helpful GUI packages.";
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages to install for this specific machine.";
    };
  };

  config = {
    # Shared nixpkgs config
    nixpkgs = {
      config.allowUnfree = true;
      overlays = [
        nix-vscode-extensions.overlays.default
      ];
    };

    # Shared nix config
    nix = {
      enable = true;
      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      };
      settings = {
        experimental-features = "nix-command flakes";
        warn-dirty = false; # usually is anyways
      };
      # Old, prefer flakes
      channel.enable = false;
    };

    # Fonts
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];

    # Install Zsh system-wide
    programs.zsh.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit username; };
      backupFileExtension = "bak";

      users.${username} = {
        home = {
          inherit username;
          stateVersion = "25.11";

          packages = lib.flatten [
            # Essential CLI tools
            (with pkgs; [
              zsh
              eza
              bat
              btop
              ripgrep
              fd
            ])

            # Extra CLI suite
            (lib.optionals cfg.getStdCliPkgs (
              with pkgs;
              [
                nixd
                nixfmt
                wget
                cowsay
              ]
            ))

            # Extra GUI suite
            (lib.optionals cfg.getStdGuiPkgs (
              with pkgs;
              [
                firefox-unwrapped
                discord
                zoom-us
              ]
            ))

            # Extension hook
            cfg.extraPackages
          ];
        };

        programs = {
          home-manager.enable = true;

          # Standard CLI suite
          eza.enable = true;
          bat.enable = true;
          btop.enable = true;
          ripgrep.enable = true;

          zoxide = {
            enable = true;
            enableZshIntegration = true;
          };

          direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv.enable = true;
          };
        };

        xdg.enable = true;
      };
    };
  };
}
