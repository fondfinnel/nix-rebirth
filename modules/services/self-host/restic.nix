# TODO sops
# TODO test
{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {

    sops.secrets = {
      "restic.encryption" = {};
      "restic.photos" = {};
    };

    services.restic = let

      initialize = lib.mkDefault true;
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 10"
      ];
      timerConfig.OnCalendar = "sunday 3:00";
      timerConfig.Persistent = true;
      passwordFile = config.sops.secrets."restic.encryption".path;

      # todo 
      # - services.restic.backups.photos: exactly one of repository, repositoryFile or environmentFile should be set

    in {
      server.enable = lib.mkDefault true;


      
      backups."photos" = {
        inherit initialize pruneOpts timerConfig passwordFile;

        repositoryFile = config.sops.secrets."restic.photos".path;

        paths = [
          "/mnt/NAS/Media/Photos"
        ];

        exclude = [
          "Other Junk/*"
        ];

      };
    };

  };


}
