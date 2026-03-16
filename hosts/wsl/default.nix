{
  ...
}:
{
  imports = [
    ../shared
    ../../modules/wsl
  ];

  # Choose features
  features = {
    # Shared packages
    getStdCliPkgs = true;
    getStdGuiPkgs = false;

    # Custom packages
    vim.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    vscode.enable = true;
  };
}
