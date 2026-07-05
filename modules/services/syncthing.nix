{ self, inputs, ... }: {

  flake.nixosModules.syncthing = { config, ... }: {

    home.preserve.directories = [ ".config/syncthing" ];

    services.syncthing = { 
      enable = true;
      user = "n0ll"; # User for syncthing
      extraFlags = [ "--allow-newer-config" ];
      guiAddress = "localhost:8384"; # Local access to the GUI
      settings = {
        guiCredentials.username = config.home.username;
        guiCredentials.password = config.sops.secrets."syncthing".path;

        gui = {
          theme = "black";
          options.urAccepted = -1;
        };

	      devices = let
          autoAcceptFolders = true;
          introducer = true;
        in {
          "laptop" = { id = "YGGBNE3-6LMN6LP-NWN4TD5-UHGCFTP-4ULXIFL-IEVFP5F-L2WO56A-T3XJLAE"; autoAcceptFolders = auto; };
          "desktop" = { id = "MF6NA23-4SGNP2G-R3OOCCW-AQV6PJS-K6SQ4W2-OYEUYOU-J2W7LJG-VZUVKAU"; autoAcceptFolders = auto; };
          "solidus" = { id = "G3S2NHM-RR2ZKKV-WARQLM6-EQ2A3U7-IMSDVKM-C7NM6ZU-KCTOGSF-U5HEVAQ"; autoAcceptFolders = auto; };
          "phone" = { id = "KSTSL6T-HH4GJ53-3IRONUA-CNWJ6XX-L4K2NPZ-VV3ENH5-ZVXWZO2-O5YSZA2"; autoAcceptFolders = false; };
          "boox" = { id = "EJHWUSC-MOXVHOV-3KI2HJ6-GHNOGCU-UHOGCR6-UOOPMN2-6LHGKAK-IITLOQP"; autoAcceptFolders = false; };
        };

        folders = let
          myDevices = [ "phone" "desktop" "laptop" "boox" ];
          simple={type="simple";params={keep="3";};}; # simple versioning, keep 3 dupes
        in {
          "Obsidian - n0ll" = {
            path = "/home/n0ll/Obsidian - n0ll";
            devices = myDevices;
            versioning = simple;
          };
          "Keepass" = {
            path = "/home/n0ll/Keepass";
            devices = myDevices;
            versioning = simple;
          };
          "Books-Share" = {
            path = "/home/n0ll/Books-Share";
            devices = [ "boox" ];
            
          };
          "Photo-Share" = {
            path =
              if config.networking.hostName == "NateNix" then "/mnt/NAS/Media/Photos/DSLR/Share"
              else "/home/n0ll/Photo-Share";
            devices = [ "phone" "solidus" "desktop" "laptop" ];
            versioning = simple;
          };
          "logseq" = {
            path = "/home/n0ll/logseq";
            devices = [ "phone" "desktop" "laptop" "boox" ];
            versioning = simple;
          };
          "org" = {
            path = "/home/n0ll/org";
            devices = [ "phone" "desktop" "laptop" "boox" ];
            versioning = simple;
          };
	      };
	      overideDevices = true;
        overrideFolders = true;
		  };

      tray.enable = lib.mkDefault config.services.syncthing.enable;
	  };

    
  };
}
