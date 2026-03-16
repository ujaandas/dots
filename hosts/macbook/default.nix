{
  pkgs,
  ...
}:
{
  imports = [
    ../shared
    ../../modules/darwin
  ];

  # Choose features
  features = {
    # System settings
    useTouchIdSudo = true;
    useSaneSystemSettings = true;

    # Shared packages
    getStdCliPkgs = true;
    getStdGuiPkgs = true;

    # Custom packages
    vim.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    kitty.enable = true;
    vscode.enable = true;

    # Darwin-specific packages
    extraPackages = with pkgs; [
      obsidian
      rectangle
      alt-tab-macos
    ];

    # Not on nixpkgs, use Homebrew cask
    extraCasks = [
      "alfred"
    ];
  };
}
