{ lib, config, specialArgs, username, pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = lib.mkForce true; # use global nixpkgs
    useUserPackages = lib.mkForce true; # allow user defined pkgs
    extraSpecialArgs = lib.mkForce specialArgs; # pass extra args to hm modules
    sharedModules = lib.mkBefore [ ];

    # define hm config for the user
    users.${username} = { pkgs, ... }: {
      home = {
        username = lib.mkForce username;
        stateVersion = lib.mkForce "25.05";

        # default apps
        packages = lib.mkBefore ( builtins.import ./apps.nix { inherit pkgs; } );
      };

      programs = {
        # enable and let hm install itself
        home-manager.enable = lib.mkForce true;

        # trying out vscodium
        vscode = lib.mkForce ( builtins.import ./pkgs/vscode.nix { inherit pkgs lib; });
      };

      # xdg sup
      xdg.enable = lib.mkForce true;
    };
  };
}