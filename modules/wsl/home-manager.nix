{
  lib,
  config,
  username,
  pkgs,
  ...
}:
{
  imports = [
    ../shared/home-manager.nix
  ];

  # define my user with visible home dir and shell and wtv else
  users.users.${username} = {
    name = username;
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.zsh;
    uid = lib.mkForce 1001;
  };

  home-manager = {
    # define hm config for the user
    users.${username} =
      { pkgs, ... }:
      {
        home = {
          # my apps
          packages = lib.mkAfter (builtins.import ./packages.nix { inherit pkgs; });
        };
      };
  };
}
