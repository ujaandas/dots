{
  config,
  pkgs,
  username,
  wsl,
  ...
}:
{
  imports = [
    ../shared
    ../../modules/wsl/home-manager.nix
  ];

  system.stateVersion = "25.05";
  wsl.enable = true;
  wsl.defaultUser = "ooj";

  nixpkgs.hostPlatform = "x86_64-linux";
}
