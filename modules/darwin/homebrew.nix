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
      # dev tools
      "homebrew/cask/docker"
      "visual-studio-code"
      "wezterm"

      # productivity
      "obsidian"
      "alfred"
      "alt-tab"

      # browser
      "firefox"

      # communication
      "discord"
      "zoom"
    ];
    taps = builtins.attrNames config.nix-homebrew.taps; # align tap config with nix-homebrew
  };
}