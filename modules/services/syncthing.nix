{ self, inputs, ... }: {

  flake.homeModules.syncthing = { lib, config, osConfig, ... }: let
    # get list of dirs from syncthing shares
    dirs = lib.mapAttrsToList (_: value: value.path) config.services.syncthing.settings.folders;

    # convert to shares based on relative path to home
    relativeDirs = lib.map (f: lib.removePrefix "${config.home.homeDirectory}/" f) dirs;

    # filter out anything outside of home
    filteredDirs = builtins.filter (path: !lib.strings.hasPrefix "/" path) relativeDirs;
  in {

    home.preserve.directories = [
      ".config/syncthing"
    ] ++ filteredDirs;

    sops.secrets = let
      sopsFile = ./hosts-secrets.yaml;
      reloadUnits = [ "syncthing.service" ];
    in {
      "${osConfig.networking.hostName}/syncthing/cert" = { inherit sopsFile reloadUnits; };
      "${osConfig.networking.hostName}/syncthing/key" = { inherit sopsFile reloadUnits; };
    };

    services.syncthing = { 
      enable = true;
      guiAddress = "localhost:8384"; # Local access to the GUI

      cert = config.sops.secrets."${osConfig.networking.hostName}/syncthing/cert".path;
      key = config.sops.secrets."${osConfig.networking.hostName}/syncthing/key".path;

      settings = {
        guiCredentials.username = config.home.username;
        guiCredentials.password = config.sops.secrets."syncthing".path;

        gui = {
          theme = "black";
          options.urAccepted = -1;
        };

        # TODO update all device IDs
	      devices = let

          autoAcceptFolders = true;
          introducer = true;

        in {

          "nix-solid" = {
            inherit autoAcceptFolders introducer;
            id = "MF6NA23-4SGNP2G-R3OOCCW-AQV6PJS-K6SQ4W2-OYEUYOU-J2W7LJG-VZUVKAU";
          };

          "laptop" = {
            inherit autoAcceptFolders introducer;
            id = "YGGBNE3-6LMN6LP-NWN4TD5-UHGCFTP-4ULXIFL-IEVFP5F-L2WO56A-T3XJLAE";
          };

          "solidus" = {
            inherit autoAcceptFolders introducer;
            id = "G3S2NHM-RR2ZKKV-WARQLM6-EQ2A3U7-IMSDVKM-C7NM6ZU-KCTOGSF-U5HEVAQ";
          };

          "phone" = {
            inherit autoAcceptFolders introducer;
            id = "KSTSL6T-HH4GJ53-3IRONUA-CNWJ6XX-L4K2NPZ-VV3ENH5-ZVXWZO2-O5YSZA2";
          };

          "boox" = {
            inherit autoAcceptFolders introducer;
            id = "EJHWUSC-MOXVHOV-3KI2HJ6-GHNOGCU-UHOGCR6-UOOPMN2-6LHGKAK-IITLOQP";
          };

        };

        folders = let

          devices = [
            "phone" "desktop" "laptop" "boox"
          ];
          versioning = {
            type="simple";
            params.keep="3";
          }; # simple versioning, keep 3 dupes

        in {

          "Keepass" = {
            path = "${config.home.homeDirectory}/Keepass";
            inherit versioning devices;
          };

          "Books-Share" = {
            inherit versioning devices;
            path = "${config.home.homeDirectory}/Books-Share";            
          };

          "Photo-Share" = {
            inherit versioning devices;
            path =
              if osConfig.networking.hostName == "nix-solid" then "/mnt/NAS/Media/Photos/DSLR/Share"
              else "${config.home.homeDirectory}/Photo-Share";
          };

          "logseq" = {
            inherit versioning devices;
            path = "${config.home.homeDirectory}/logseq";
          };

          "org" = {
            inherit versioning devices;
            path = "${config.home.homeDirectory}/org";
          };

	      };

	      overideDevices = true;
        overrideFolders = true;

		  };

      tray.enable = lib.mkDefault config.services.syncthing.enable;
	  };

    
  };
}
