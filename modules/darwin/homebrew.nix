{ config, username, homebrew-core, homebrew-cask, ... }: 
{
  # declarative installation of homebrew
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };

    mutableTaps = false; # declaratively manage taps
  };

  homebrew = {
    enable = true;
    # gui apps i need
    casks = [
      # for now, replaced with home-manager with recent fix
    ];
    taps = builtins.attrNames config.nix-homebrew.taps; # align tap config with nix-homebrew
    onActivation.cleanup = "zap"; # run `brew uninstall --zap` for all formulae not in brewfile
  };
}