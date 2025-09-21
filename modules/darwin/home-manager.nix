{
  lib,
  config,
  specialArgs,
  username,
  pkgs,
  ...
}: {
  imports = [
    ../shared/home-manager.nix
    ./app-plist-settings.nix
  ];

  # define my user with visible home dir and shell and wtv else
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    isHidden = false;
  };

  # override default application linking with a custom set
  # from https://github.com/nix-community/home-manager/issues/1341#issuecomment-3256894180
  system.build.applications = lib.mkForce (
    pkgs.buildEnv {
      name = "system-applications";
      pathsToLink = "/Applications";

      # combine system packages with all user home packages
      paths =
        config.environment.systemPackages
        ++ (builtins.concatMap (x: x.home.packages) (lib.attrsets.attrValues config.home-manager.users));
    }
  );

  home-manager = {
    sharedModules = lib.mkAfter [
      # disable automatic app linking by hm
      {targets.darwin.linkApps.enable = false;}
    ];

    # define hm config for the user
    users.${username} = {pkgs, ...}: {
      home = {
        # inherit username; # no need for this as we mkForce username in shared/
        homeDirectory = "/Users/${username}";

        # my apps
        packages = lib.mkAfter (builtins.import ./packages.nix {inherit pkgs;});
      };
    };
  };
}
