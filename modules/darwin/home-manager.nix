{ lib, config, specialArgs, username, pkgs, ... }:
{

  # define my user with visible home dir and shell and wtv else
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    isHidden = false;
    shell = pkgs.zsh;
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
        ++ (builtins.concatMap (x: x.home.packages) (builtins.attrsets.attrValues config.home-manager.users));
    }
  );

  home-manager = {
    useGlobalPkgs = true; # use global nixpkgs
    useUserPackages = true; # allow user defined pkgs
    extraSpecialArgs = specialArgs; # pass extra args to hm modules
    sharedModules = [
      # disable automatic app linking by hm
      { targets.darwin.linkApps.enable = false; }
    ];

    # define hm config for the user
    users.${username} = { pkgs, ... }: {
      home = {
        inherit username;
        homeDirectory = "/Users/${username}";
        stateVersion = "25.05";
        
        # my apps
        packages = with pkgs; [ 
          iterm2 
        ];
      };

      # enable and let hm install itself
      programs = {
        home-manager.enable = true;
      };

      # xdg sup
      xdg.enable = true;
    };
  };
}