{ lib, username, ... }:
{
  imports = [
    ../home.nix # Pull in all base options
    ./system.nix # Get system settings
    ./homebrew.nix # Get Homebrew stuff
  ];

  config = {
    # Darwin-specific Nix settings
    nixpkgs.hostPlatform = lib.mkForce "aarch64-darwin";

    # Darwin-specific HM settings
    home-manager = {
      sharedModules = [
        { targets.darwin.linkApps.enable = false; }
      ];
      users.${username}.home.homeDirectory = lib.mkForce "/Users/${username}";
    };

    # Configure userspace
    users.users.${username} = {
      name = username;
      home = "/Users/${username}";
      isHidden = false;
    };
  };
}
