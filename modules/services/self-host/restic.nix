# TODO sops
# TODO test
{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {

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
      passwordFile = config.sops.secrets.restic-encryption.path;

    in {
      enable = lib.mkDefault true;

      backups."photos" = {
        inherit initialize pruneOpts timerConfig passwordFile;

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
