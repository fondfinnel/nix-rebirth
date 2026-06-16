# TODO for NAS: routine maintenance on music
# TODO add preservation whitelisted dirs and files
# TODO for NAS: Write different module for mpd as host

{ config, pkgs, self, ... }: {

  flake.homeModules.mpd = { lib, pkgs, config, osConfig, ... }: {

    imports = with self.homeModules; [
      beets
    ];

    home.packages = lib.mkIf config.services.mpd.enable [
      pkgs.mpc
      (pkgs.writeShellScriptBin "newmusic" ''
      cd ${config.services.mpd.musicDirectory} &&
        ${pkgs.beets}/bin/beet import -q unsorted &&
        ${pkgs.sacad}/bin/sacad_r -i unsorted 1400 cover.jpg &&
        ${pkgs.loudgain}/bin/rgbpm unsorted -b &&
        ${pkgs.fd}/bin/fd -C unsorted -t file -x ${pkgs.bpm-tools}/bin/bpm-tag -f
       '')
    ];

	  services.mpd = let
      check = if osConfig.device-type == "primary" then true else
        if osConfig.device-type == "server" then true
        else false;
      musicDirectory = config.services.mpd.musicDirectory;
    in {
	    enable = lib.mkDefault check;
      # TODO reassign values if server is acting as host, connecting as client
      musicDirectory = "/mnt/NAS/Media/Music";
      playlistDirectory = "${musicDirectory}/playlists";
      dbFile = "${musicDirectory}/.database/mpd/database";
      extraConfig = ''
      sticker_file "${musicDirectory}/.database/mpd/${config.home.username}_sticker.sql"
      log_file "${musicDirectory}/.database/mpd/${config.home.username}_log"

      audio_output { # foo output for visualizers, such as cava
        type "fifo"
        name "my_fifo"
        path "/tmp/mpd.fifo"
        format "44100:16:2"
      }

      ${if config.services.pipewire.enable then ''
      audio_output { # pipewire output
        type "pipewire"
        name "PipeWire"
        format "384000:f:2"
      }
      '' else ''''}
      replaygain "auto"
      max_output_buffer_size "16384"
      mixramp_analyzer "yes"
    '';

      extraArgs = [ "--verbose" ];

	  };

    services.mpd-mpris.enable = lib.mkDefault config.services.mpd.enable;

    services.mpd-discord-rpc = {
      enable = lib.mkDefault (config.programs.vesktop.enable && config.services.mpd.enable);

      settings.format = {
        details = "$title";
        state = "$artist";
      };
    };

    home.persistence."/persistent".directories = [
      config.services.mpd.musicDirectory      
    ];


  };

}
