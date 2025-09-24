{ lib, pkgs, ... }:
{
  enable = true;

  # basic stuff
  autocd = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  # history
  history = {
    size = 10000;
    save = 10000;
    share = true;
    ignoreDups = true;
    ignoreSpace = true;
    extended = true;
  };

  # aliases
  shellAliases = {
    ls = "eza --icons=always $@";
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
  initContent = lib.mkBefore ''
    export EDITOR=nvim
    export FZF_DEFAULT_COMMAND="fd --type f"
    eval "$(zoxide init zsh)"
    eval "$(direnv hook zsh)"
    source ${./p10k.zsh}
  '';

  # plugins
  plugins = [
    {
      name = pkgs.zsh-powerlevel10k.pname;
      inherit (pkgs.zsh-powerlevel10k) src;
      file = "powerlevel10k.zsh-theme";
    }
  ];
}
