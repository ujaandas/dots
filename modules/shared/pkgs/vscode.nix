{ pkgs, lib, ... }: {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
        extensions = with pkgs.vscode-extensions; [
            dracula-theme.theme-dracula
        ];
    };
}