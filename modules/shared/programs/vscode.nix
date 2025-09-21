{
  pkgs,
  lib,
  ...
}: {
  enable = true;
  package = pkgs.vscodium;

  profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      # themes
      catppuccin.catppuccin-vsc

      # dev
      jnoortheen.nix-ide
      eamodio.gitlens
    ];

    userSettings = {
      # ui pref
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "vscode-icons";
      "workbench.sideBar.location" = "left";
      "window.menuBarVisibility" = "classic";

      # font
      "editor.fontFamily" = "'JetBrains Mono', Consolas, 'Courier New', monospace";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 14;

      # fmt/linting
      "editor.formatOnSave" = true;
      "editor.codeActionsOnSave" = {
        "source.fixAll.eslint" = true;
        "source.organizeImports" = true;
      };

      # intellisense
      "editor.quickSuggestions" = {
        "other" = true;
        "comments" = false;
        "strings" = true;
      };

      # shell
      "terminal.integrated.fontFamily" = "JetBrains Mono";
      "terminal.integrated.defaultProfile.linux" = "bash";

      # gitlens
      "gitlens.currentLine.enabled" = true;
      "gitlens.hovers.enabled" = true;

      # misc
      "breadcrumbs.enabled" = true;
    };
  };
}
