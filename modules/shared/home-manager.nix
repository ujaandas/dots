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
        packages = with pkgs; lib.mkBefore [ 
          cowsay
        ];
      };

      # enable and let hm install itself
      programs = {
        home-manager.enable = lib.mkForce true;
      };

      # xdg sup
      xdg.enable = lib.mkForce true;
    };
  };
}