{
  self,
  inputs,
  config,
  ...
}:
{

  flake.homeModules.beets =
    {
      config,
      osConfig,
      lib,
      pkgs,
      ...
    }:
    {

      home.packages = lib.mkIf config.programs.beets.enable [
        # alias for splitting cue files
        (pkgs.writeShellScriptBin "split-cue" "${pkgs.fd}/bin/fd cue --exec ${pkgs.unflac}/bin/unflac -o ${config.programs.beets.settings.directory}")
        pkgs.kid3

        # plugin dependencies
        pkgs.ffmpeg # replaygain
        pkgs.chromaprint # chroma
        pkgs.imagemagick # fetchart

      ];

      programs.beets =
        let
          heaven = osConfig.networking.hostName == "nix-heaven";
          mpdDir =
            if heaven then
              osConfig.services.mpd.settings.music_directory
            else
              config.services.mpd.musicDirectory;
        in
        {
          enable = if heaven then true else lib.mkDefault config.services.mpd.enable;

          settings = lib.mkDefault {
            directory = "${mpdDir}/Library";
            library = "${mpdDir}/.database/beets/database.db";

            plugins = [
              "chroma"
              "albumtypes"
              "mbpseudo"
              "discogs"
              "missing"
              "autobpm"
              "fetchart"
              "replaygain"
              "duplicates"
              "beetcamp"
            ];

            import = {
              # How does beets import music?
              move = true;
              copy = false;
              resume = true;
              write = true;
              log = "${mpdDir}/.database/beets/log.txt";
              bell = true;
            };

            asciify_path = true;
            albumtypes = {
              # How should beets handle albums?
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

            paths =
              let
                shared = "$album ($year)/Disc $disc";
              in
              rec {
                # How should filenames be written?
                # ref:
                #   https://beets.readthedocs.io/en/stable/plugins/albumtypes.html
                #   https://beets.readthedocs.io/en/stable/reference/pathformat.html
                default = "$albumartist/$atype/${shared}/$track - title";
                comp = "Various Artists/${shared}/$track - $artist - $title";
              };

            # Maintanence, mostly defaults left alone. See beets docs for info on the rest.
            duplicates.full = true;

            check = {
              import = true;
              write-check = true;
              write-update = true;
              convert-update = true;
              threads = 4;
            };

            # Other
            ui.color = true;

            # various plugin settings
            chroma.auto = true;
            lyrics = {
              auto = true;
              synced = true;
              translated = "en";
            };
            replaygain.backend = "ffmpeg";
            missing = {
              count = true;
              total = true;
            };
            fetchart.cover_format = "jpeg";
            fetchart.max_filesize = "1MiB";
          };
        };

      # don't want to ditch discogs auth token
      home.preserve.directories = [ ".config/beets" ];

    };

}
