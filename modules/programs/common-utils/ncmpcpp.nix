{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { lib, config, pkgs, ... }: {
    programs.ncmpcpp = {
      # enable by default if rmpc is disabled and mpd is enabled
      enable = lib.mkDefault (config.programs.rmpc.enable == false) == (config.services.mpd.enable == true);
      package = pkgs.ncmpcpp.override { visualizerSupport = true; clockSupport = true; }; # build with extra stuff
      bindings = [ # vim binds for ncmpcpp
        { key = "j"; command = "scroll_down"; }
        { key = "k"; command = "scroll_up"; }
        { key = "J"; command = [ "select_item" "scroll_down" ]; }
        { key = "K"; command = [ "select_item" "scroll_up" ]; }
        { key = "l"; command = "next_column"; }
        { key = "h"; command = "previous_column"; }
      ];
      settings = lib.mkDefault {
        # mpd_crossfade_time = "10";
        media_library_primary_tag = "album_artist";
        data_fetching_delay = "yes";
        header_visibility = "no";
        # store_lyrics_in_song_dir = "yes";
        follow_now_playing_lyrics = "yes";
        fetch_lyrics_for_current_song_in_background = "yes";
        display_remaining_time = "yes";
        display_bitrate = "yes";
        now_playing_prefix = "$2>>>$9";
      };
    };

  };


}
