{ self, inputs, ... }: {

  flake.homeModules.syncthing =
    {
      lib,
      config,
      osConfig,
      ...
    }:
    let
      # get list of dirs from syncthing shares
      dirs = lib.mapAttrsToList (_: value: value.path) config.services.syncthing.settings.folders;

      # convert to shares based on relative path to home
      relativeDirs = lib.map (f: lib.removePrefix "${config.home.homeDirectory}/" f) dirs;

      # filter out anything outside of home
      filteredDirs = builtins.filter (path: !lib.strings.hasPrefix "/mnt" path) relativeDirs;
    in
    {

      home.preserve.directories = [
        ".config/syncthing"
        ".local/state/syncthing"
      ]
      ++ filteredDirs;

      services.syncthing = {
        enable = true;
        guiAddress = if !osConfig.headless-check then "0.0.0.0:8384" else "localhost:8384"; # Local access to the GUI

        cert = config.sops.secrets."syncthing/${osConfig.networking.hostName}/cert".path;
        key = config.sops.secrets."syncthing/${osConfig.networking.hostName}/key".path;

        settings = {
          guiCredentials.username = config.home.username;
          guiCredentials.password = config.sops.secrets."syncthing/gui".path;

          gui = {
            theme = "black";
            options.urAccepted = -1;
          };

          # TODO update all device IDs
          devices =
            let

              autoAcceptFolders = true;
              introducer = true;

            in
            {

              "nix-solid" = {
                inherit autoAcceptFolders introducer;
                id = "MF6NA23-4SGNP2G-R3OOCCW-AQV6PJS-K6SQ4W2-OYEUYOU-J2W7LJG-VZUVKAU";
              };

              "nix-shalashaska" = {
                inherit autoAcceptFolders introducer;
                id = "24ATCGC-6TBQK4E-GIPJQTQ-JLNE6YS-ZPUOHUN-SHLSITF-S4MRLZL-T7O5ZQ3";
              };

              "nix-heaven" = {
                inherit autoAcceptFolders introducer;
                id = "QGXFP5Z-O4KFFG7-H7AAG34-OG2WW4L-VURGEJX-WWGIPG5-6RZJGSM-DWKWOA3";
              };

              "fairphone" = {
                id = "CQ7UF6K-Q6E4U4B-4GYGMZZ-3EMIWRD-6O423QP-LV36RSV-5DG4TOB-PEQZQAR";
              };

              "boox" = {
                id = "EJHWUSC-MOXVHOV-3KI2HJ6-GHNOGCU-UHOGCR6-UOOPMN2-6LHGKAK-IITLOQP";
              };

            };

          folders =
            let

              allDevices = [
                "nix-shalashaska"
                "fairphone"
                "boox"
                "nix-heaven"
              ];

              mainDevices = [
                "nix-heaven"
                "nix-solid"
              ];

              versioning = {
                type = "simple";
                params.keep = "3";
              }; # simple versioning, keep 3 dupes

            in
            {

              "Keepass" = {
                path = "${config.home.homeDirectory}/Keepass";
                inherit versioning;
                devices = allDevices;
              };

              "org" = {
                inherit versioning;
                path = "${config.home.homeDirectory}/org";
                devices = allDevices;
              };

              "Photo-Share" = {
                inherit versioning;
                path =
                  # TODO needs changed, could cause write errors
                  if osConfig.networking.hostName == "nix-solid" then
                    "/mnt/NAS/Media/Photos/DSLR/Share"
                  else if osConfig.networking.hostName == "nix-heaven" then
                    "/Primary/Personal/Media/Photos/DSLR"
                  else
                    "${config.home.homeDirectory}/Photo-Share";
                devices = allDevices;
              };

              "logseq" = {
                inherit versioning;
                path = "${config.home.homeDirectory}/logseq";
                devices = mainDevices;
              };

              "Books-Share" = {
                inherit versioning;
                path = "${config.home.homeDirectory}/Books-Share";
                devices = mainDevices;
              };

              phoneMusic = lib.mkIf (osConfig.networking.hostName == "nix-heaven") {
                # symlinked dirs for phone music library
                # no need to version, only want it on phone
                devices = [ "fairphone" ];
                path = "/Primary/Personal/Media/phone-music";
              };

            };

          overideDevices = true;
          overrideFolders = true;

        };

        tray.enable = lib.mkDefault false;
      };

    };
}
