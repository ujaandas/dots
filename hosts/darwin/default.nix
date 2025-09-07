{ config, pkgs, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix = {
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  system = {
    stateVersion = 6;
    configurationRevision = config.rev or config.dirtyRev or null;
  };
}