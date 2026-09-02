{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.keepassxc = { lib, ... }: {

    programs.keepassxc = {
      enable = lib.mkDefault check;

      settings = {
        # fix for nix binary paths conflicting with plugin, according to docs
        Browser.updateBinaryPath = false;

        Browser.Enabled = true;

        GUI = {
          ApplicationTheme = "classic";
          CompactMode = true;

          ShowTrayIcon = true;
          TrayIconAppearance = "monochrome-light";

          HidePasswords = true;
          CheckForUpdates = false;
          MinimizeOnClose = true;
          MinimizeOnStartup = true;

          ColorPasswords = true;
          MonospaceNotes = true;
          AdvancedSettings = true;
        };

        Security = {
          LockDatabaseIdle = true;
          LockDatabaseIdleSeconds = "7200";
        };

        # have it handle libsecret, don't confirm when something is being used
        FdoSecrets = {
          Enabled = true; 
          ConfirmAccessItem = false;
        };    

        SSHAgent.Enabled = true;    
      };

    };

    # keep previous selected file when rebooting
    home.preserve.directories = [
      ".cache/keepassxc"
    ];

  };

}
