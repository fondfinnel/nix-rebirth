{ self, inputs, config, ... }: {

  flake.nixosModules.base = { lib, config, ... }: let
    # Locale
    lc = "en_US.UTF-8";
  in {

    # Set env variable
    environment.variables.TZ = lib.mkDefault config.time.timeZone;

    # Set system timezone
    time.timeZone = lib.mkDefault "America/New_York";

    services.ntp.enable = lib.mkDefault true;  

    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
    i18n.extraLocaleSettings = let
      lc = config.i18n.defaultLocale;
    in lib.mkDefault {
      LC_ADDRESS = lc;
      LC_IDENTIFICATION = lc;
      LC_MEASUREMENT = lc;
      LC_MONETARY = lc;
      LC_NAME = lc;
      LC_NUMERIC = lc;
      LC_PAPER = lc;
      LC_TELEPHONE = lc;
      LC_TIME = lc;
    };
    
    # Configure keymap in X11
    services.xserver.xkb = lib.mkDefault {
      layout = "us";
      variant = "";
    };
  };

}
