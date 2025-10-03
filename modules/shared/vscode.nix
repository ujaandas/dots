{
  pkgs,
  ...
}:
{
  enable = true;
  package = pkgs.vscodium;

  profiles.default = {
    extensions =
      let
        marketplaceExt = with pkgs.vscode-marketplace; [
          catppuccin.catppuccin-vsc
          jnoortheen.nix-ide
          eamodio.gitlens
          usernamehw.errorlens
          golang.go
          bradlc.vscode-tailwindcss
          charliermarsh.ruff
          esbenp.prettier-vscode
          dbaeumer.vscode-eslint
        ];
        openVsxExt = with pkgs.open-vsx; [
          jeanp413.open-remote-ssh
          # ms-toolsai.jupyter # bugged out version, downgrade?
        ];
      in
      marketplaceExt ++ openVsxExt;

    userSettings = {
      # ui pref
      "workbench.colorTheme" = "Catppuccin Mocha";
      # "workbench.iconTheme" = "vscode-icons";
      "workbench.sideBar.location" = "right";
      # "window.menuBarVisibility" = "classic";
      "breadcrumbs.enabled" = false;
      "editor.overviewRulerBorder" = false;
      "workbench.layoutControl.enabled" = false;
      "explorer.autoReveal" = false;
      "editor.minimap.enabled" = false;
      "workbench.tree.indent" = 12;
      "workbench.tree.renderIndentGuides" = "none";
      "workbench.editor.tabActionCloseVisibility" = false;
      "editor.padding.bottom" = 14;
      "editor.padding.top" = 14;
      "editor.scrollbar.horizontal" = "hidden";
      "editor.matchBrackets" = "never";
      "editor.guides.highlightActiveBracketPair" = false;
      "editor.smoothScrolling" = true;
      "explorer.compactFolders" = false;
      "zenMode.fullScreen" = false;

      # font
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', Consolas, 'Courier New', monospace";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 13;

      # fmt/linting
      "editor.formatOnSave" = true;
      "files.associations" = {
        "*.css" = "tailwindcss";
      };

      # intellisense
      "editor.quickSuggestions" = {
        "other" = true;
        "comments" = false;
        "strings" = true;
      };

      # shell
      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
      "terminal.integrated.defaultProfile.linux" = "bash";

      # gitlens
      "gitlens.currentLine.enabled" = true;
      "gitlens.hovers.enabled" = true;

      # language specific
      "nix" = {
        "serverPath" = "nixd";
        "enableLanguageServer" = true;
        "serverSettings.nixd.formatting.command" = "nixfmt";
      };
      "tailwindCSS.includeLanguages" = {
        "html" = "html";
        "javascript" = "javascript";
        "css" = "css";
      };
    };
  };
}
