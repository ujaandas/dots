{
  lib,
  ...
}:
{
  enable = true;

  # basic stuff, duh
  autocd = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  # sane aliases
  shellAliases = {
    ls = "eza --icons";
    ll = "eza -l";
    la = "eza -la";
    cat = "bat --paging=never";
    top = "btop";
    cd = "z";
    grep = "rg";
    find = "fd";
    vim = "nvim";
  };

  # init extra
  initContent = ''
    export EDITOR=nvim
    export FZF_DEFAULT_COMMAND="fd --type f"
    eval "$(zoxide init zsh)"
    eval "$(direnv hook zsh)"
  '';
}
