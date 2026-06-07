{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.nixosModules.gnome = { lib, config, pkgs, ... }: {

    services.desktopManager.gnome.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

    # Auto login tweaks
    systemd.services."autovt@tty1".enable = false;
    systemd.services."gettiy@tty1".enable = false;

    # Don't install all the bullshit with gnome.
    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
      gedit
    ]) ++ (with pkgs.gnome; [ 
      gnome-music
      epiphany
      geary
      gnome-characters
      totem
      tali
      iagno
      hitori
      atomix
    ]);

    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    # Set up user environment
    home-manager.sharedModules = [{

      dconf = {
        enable = true;

        # Enable dark theme
        settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

        # Install plugins
        settings."org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs.gnomeExtensions; [
            forge.extensionUuid
            gsconnect.extensionUuid
            desaturated-tray-icons.extensionUuid
            weather-or-not.extensionUuid
            tomatoc-to-panel.extensionUuid
          ];
        };
      };

    }];

  };

}
