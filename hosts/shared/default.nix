{
  config,
  pkgs,
  username,
  nix-vscode-extensions,
  ...
}:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      nix-vscode-extensions.overlays.default
    ];
  };

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

    # old, prefer flakes
    channel.enable = false;
  };

  # fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # zsh
  programs.zsh.enable = true;

  # git
  programs.git.enable = true;
}
