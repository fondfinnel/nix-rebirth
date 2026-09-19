# TODO for NAS: routine maintenance on music

{ config, pkgs, self, ... }: {


  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    musicDirectory = config.services.mpd.settings.music_directory;
  in {

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${musicDirectory}"
      "${musicDirectory}/.database/playlists"
    ];


    services.mpd = {
      enable = true;
      openFirewall = true;
      settings = {
        bind_to_address = "any";
        music_directory = "/Primary/Personal/Media/Music";
        playlist_directory = "${musicDirectory}/.database/mpd/playlists";
        db_file = "${musicDirectory}/.database/mpd/database";
      };
    };

    home-manager.sharedModules = let f = lib.mkForce; in [{
      services.mpd-sima.enable = f false;
      services.mpdscribble.enable = f false;
      programs.mpd-crossfade.enable = f false;
    }];

  };


}
