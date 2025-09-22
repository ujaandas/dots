_: {
  # the same attrset being changed in hosts/darwin
  # just felt cleaner to have app specific (non-system) settings here
  # well, anything that doesnt come w a config file and needs a plist change at least

  system.defaults.CustomUserPreferences = {
    "com.lwouis.alt-tab-macos.plist" = {
      startAtLogin = true; # start at login
      "NSStatusItem Visible Item-0" = false; # show menubar icon (must set manually, idk why)
      SUAutomaticallyUpdate = true; # autoupdate
      SUEnableAutomaticChecks = true; # autocheck for update
      appearanceStyle = "0"; # follow system theme
      crashPolicy = "0"; # dont report crashes
      cursorFollowFocusEnabled = false; # dont follow cursor
      hideShowAppShortcut = ""; # hide app shortucut
      holdShortcut = "⌘"; # use cmd tab
      menubarIconShown = false; # dont show in menubar
      mouseHoverEnabled = false; # dont allow mouse to change window
      vimKeysEnabled = false; # disable vim keys
    };
  };
}
