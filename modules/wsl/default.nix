{
  lib,
  username,
  pkgs,
  ...
}:
{
  imports = [
    ../shared # Pull in all base options
  ];

  config = {
    # WSL-specific Nix settings
    nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
    wsl.enable = true;
    wsl.defaultUser = "ooj";
    system.stateVersion = "25.05";

    # Install git system-wide
    programs.git.enable = true;

    # Configure userspace
    users.users.${username} = {
      name = username;
      isNormalUser = true;
      home = "/home/${username}";
      shell = pkgs.zsh;
      uid = lib.mkForce 1001;
    };
  };
}
