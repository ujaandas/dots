{
  config,
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/darwin/homebrew.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix = {
    enable = true;

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    settings = {
      experimental-features = "nix-command flakes";
      warn-dirty = false; # usually is anyways
    };

    # old, prefer flakes
    channel.enable = false;
  };

  # use fingerprint for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = username;
    stateVersion = 6;
    configurationRevision = config.rev or config.dirtyRev or null;

    startup.chime = true; # fun!

    defaults = {
      NSGlobalDomain = {
        AppleICUForce24HourTime = false; # use 12hr time :)
        AppleInterfaceStyleSwitchesAutomatically = true; # auto set light/dark mode
        AppleShowScrollBars = "WhenScrolling"; # when to show scroll bars
        "com.apple.sound.beep.feedback" = 0; # sound feedback when changing volume
        "com.apple.mouse.tapBehavior" = 1; # enable tap to click
      };

      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = -1.0; # disable mouse acceleration
      };

      controlcenter = {
        BatteryShowPercentage = true; # show battery % in menu bar
        AirDrop = true; # show icon in menu bar
        FocusModes = false; # hide icon in menu bar
        Bluetooth = false;
        Display = false;
        NowPlaying = false;
        Sound = false;
      };

      dock = {
        autohide = true; # autohide the dock
        magnification = true; # magnify on hover
        showhidden = true; # show hidden apps
        minimize-to-application = true; # dont minimize to separate logo
        tilesize = 40; # dock icon size (default is 48)
        largesize = 64; # dock icon size on hover (default is 16)
        mouse-over-hilite-stack = true; # highlight window grid on hover
        # persistent-apps =
        # [

        # ];
      };

      finder = {
        AppleShowAllExtensions = true; # show file ext
        AppleShowAllFiles = true; # show hidden files
        CreateDesktop = false; # hide desktop icons
        ShowPathbar = true; # show path breadcrumbs
        ShowStatusBar = true; # show status bar with item/disk stats
        _FXShowPosixPathInTitle = true; # show full POSIX fp
        _FXSortFoldersFirst = true; # keep folders on top while sorting by name
      };

      loginwindow = {
        DisableConsoleAccess = true; # disable ability to enter '>console' in login window
        GuestEnabled = false; # disable guest account creation ability
      };

      trackpad = {
        ActuationStrength = 1; # enable silent clicking
        Clicking = true; # enable tap to click
        TrackpadRightClick = true; # enable trackpad right click (vs using control)
        TrackpadThreeFingerTapGesture = 2; # look up word
      };

      CustomUserPreferences = {
        "com.apple.AppleMultitouchTrackpad" = {
          TrackpadThreeFingerHorizSwipeGesture = 0; # disable horizontal swipe
          TrackpadThreeFingerVertSwipeGesture = 2; # swipe up for mission ctrl
          # disable 4 finger stuff
          TrackpadFourFingerHorizSwipeGesture = 0;
          TrackpadFourFingerPinchGesture = 0;
          TrackpadFourFingerVertSwipeGesture = 0;
        };

        "com.apple.desktopservices" = {
          # dont create dsstore on network/usb drives
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        "com.apple.screensaver" = {
          # ask for passwd right after sleep/screensaver
          askForPassword = 1;
          askForPasswordDelay = 0;
        };

        "com.apple.screencapture" = {
          # screenshots default to desktop as png
          location = "~/Desktop";
          type = "png";
        };

        "com.apple.print.PrintingPrefs" = {
          # autoquit printer when done
          "Quit When Finished" = true;
        };
      };
    };

    # install rosetta 2
    activationScripts.extraActivation.text = ''
      softwareupdate --install-rosetta --agree-to-license
    '';
  };
}
