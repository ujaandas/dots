{
  config,
  username,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  ...
}:
{
  # declarative installation of homebrew
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };

    mutableTaps = false; # declaratively manage taps
  };

  homebrew = {
    enable = true;
    # for now, replaced with home-manager with recent fix
    casks = [ ];
    taps = builtins.attrNames config.nix-homebrew.taps; # align tap config with nix-homebrew
    onActivation.cleanup = "zap"; # run `brew uninstall --zap` for all formulae not in brewfile
  };
}
