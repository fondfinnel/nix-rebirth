{ self, inputs, config, ... }: {

  # TODO rewrite to allow use with other services (i.e. Jellyfin)

  flake.homeModules.beets = { config, lib, pkgs, ... }: {

    home.packages = lib.mkIf config.programs.beets.enable [
      # alias for splitting cue files
      (pkgs.writeShellScriptBin  "split-cue" "${pkgs.fd}/bin/fd cue --exec ${pkgs.unflac}/bin/unflac -o ${config.programs.beets.settings.directory}")
      pkgs.kid3
    ];

    programs.beets = {
      enable = lib.mkDefault config.services.mpd.enable;

      settings = lib.mkDefault {
        directory = "${config.services.mpd.musicDirectory}/unsorted";
        mpdIntegration = { enableStats = true; enableUpdate = true; };

        import = { # How does beets import music?
          move = true;
          copy = false;
          resume = true;
          write = true;
          log = "${config.services.mpd.musicDirectory}/.database/beets/log.txt";
          bell = true;
        };

        asciify_path = true;
        albumtypes = { # How should beets handle albums?
          types = {
            ep = "EP";
            single = "Single";
            soundtrack = "OST";
            live = "Live";
            compilation = "Anthology";
            remix = "Remix";
          };
          ignore_va = "compilation";
          bracket = "[]";
        };

        # Might reorganize everything into a shallow directory for consistency, playing well with other services (Jellyfin)
        paths = { # How should filenames be written?
          default = "$albumartist/$album [$year]/($disc - $track) $title";
          # comp = "Various Artists/$album [$year]/($disc - track) $title"; 
          # albumtype:single = "$albumartist/$album [$year]/($disc - $track) $title";
          # albumtype:ep = "$albumartist/$album [$year]/($disc - $track) $title";
        };

        lyrics.synced = true;
        # Maintanence, mostly defaults left alone. See beets docs for info on the rest.
        duplicates.full = true;

        check = {
          import = true;
          write-check = true;
          write-update = true;
          convert-update = true;
          threads = 4;
        };

        missing = {
          count = true;
          total = true;
        };

        # Other
        ui.color = true;
      };
    };

    home.preserve.files = lib.mkIf config.programs.beets.enable [ ".config/beets/library.db" ];

  };


}
