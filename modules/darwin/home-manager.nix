{ username, ... }:
{
  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
  };

  home-manager = {
    useGlobalPkgs = true;
    users.${username} = { pkgs, ...}: {
      home.stateVersion = "25.05";
    };
  };
}