{ self, inputs, config, ... }:  {

  flake.homeModules.mpd = { pkgs, lib, config, ... }: {

    options.services.mpd-sima.enable = lib.mkEnableOption "mpd-sima";
    config.services.mpd-sima.enable = lib.mkDefault config.services.mpd.enable;

    config.home.preserve.directories = lib.mkIf config.services.mpd-sima.enable [ ".local/share/mpd_sima" ];

    config.systemd.user.services.mpd-sima = lib.mkIf config.services.mpd-sima.enable {

      Unit.Description = "Dynamically add music to MPD queue.";
      Install.WantedBy = [ "default.target" ];

      Service.Restart = "on-failure";
      Service.RestartSec = 30;
      
      # define service itself, followed by defining and integrating the config it will use
      # it will not appear within ~/.config
      Service.ExecStart = ( pkgs.writeShellScript "mpd-sima-service" /*bash*/ ''
      exec ${pkgs.mpd-sima}/bin/mpd-sima \
        --log-level info \
        --config ${pkgs.writeText "mpd_sima.cfg" (lib.generators.toINI {} {

          sima = {
            # it refuses to load annything but this
            interal = "Lastfm, Random, Crop";
            history_duration = 300;
            queue_length = 4;
            user_db = false;
            var_dir = "${config.xdg.dataHome}/mpd_sima";
            db_file = "${config.xdg.dataHome}/mpd_sima/sima.db";
          };

          crop.consume = 20;
          crop.priority = 0;

          lastfm = {
            queue_mode = "track";
            single_album = false;
            shuffle_album = false;
            max_art = 20;
            depth = 1; # how many tracks previously to base it's filtering on..?
            cache = true;
            track_to_add = 1;
            priority = 100;
          };

          # sensible for history based, pure for shuffle
          random.flavour = "sensible";
          random.track_to_add = 0;

          genre = {
            queue_mode = "track";
            single_album = false;
            track_to_add = 1;
          };
        })}
     '');
    };
};


}
