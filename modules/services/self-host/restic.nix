# TODO sops
# TODO test
{ self, inputs, config, ... }: {

  flake.homeModules.self-host = { lib, config, pkgs, osConfig, ... }: {

    sops.secrets = {
      "restic" = {};
    };

    home.packages = lib.mkIf config.services.restic.enable [ pkgs.restic pkgs.rclone pkgs.megacmd ];

    services.restic = let

      # initialize = true;
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 10"
      ];
      timerConfig.OnCalendar = "sunday 3:00";
      timerConfig.Persistent = true;
      passwordFile = config.sops.secrets."restic".path;

      # todo 
      # - services.restic.backups.photos: exactly one of repository, repositoryFile or environmentFile should be set

    in {
      enable = !osConfig.headless-check;

      backups."backup" = {
        inherit pruneOpts timerConfig passwordFile;
        paths = [
          "/Primary/Personal/Media/Photos"
          "/Primary/Personal/Media/Videogames/Saves"
          "/Primary/Personal/Media/Videogames/Saves"
          "/Primary/Personal/Documents"
          "/Primary/Personal/Projects"
          # "/Apps/jellyfin"
        ];

        repository = "rclone:mega-webdav:/backup";

      };
    };

  };


}
