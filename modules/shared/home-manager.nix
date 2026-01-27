{
  lib,
  specialArgs,
  username,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = lib.mkForce true; # use global nixpkgs
    useUserPackages = lib.mkForce true; # allow user defined pkgs
    extraSpecialArgs = lib.mkForce specialArgs; # pass extra args to hm modules
    sharedModules = lib.mkBefore [ ];

    backupFileExtension = "bak"; # for backup of overwrites

    # define hm config for the user
    users.${username} =
      { pkgs, ... }:
      {
        home = {
          username = lib.mkForce username;
          stateVersion = lib.mkForce "25.11";

          # default apps
          packages = lib.mkBefore (builtins.import ./packages.nix { inherit pkgs; });
        };

        programs = {
          # enable and let hm install itself
          home-manager.enable = lib.mkForce true;

          # terminal
          kitty = builtins.import ./kitty.nix { };

          # cli
          zsh = builtins.import ./zsh.nix { inherit lib pkgs; };
          eza.enable = lib.mkForce true;
          bat.enable = lib.mkForce true;
          btop.enable = lib.mkForce true;
          zoxide = {
            enable = lib.mkForce true;
            enableZshIntegration = lib.mkForce true;
          };
          ripgrep.enable = lib.mkForce true;
          fd.enable = lib.mkForce true;
          vim = builtins.import ./vim.nix;

          # direnv
          direnv = {
            enable = lib.mkForce true;
            enableZshIntegration = true;
            nix-direnv.enable = lib.mkForce true;
          };

          # trying out vscodium
          vscode = builtins.import ./vscode.nix { inherit pkgs lib; };
        };

        # xdg sup
        xdg.enable = lib.mkForce true;
      };
  };
}
