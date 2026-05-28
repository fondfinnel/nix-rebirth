# TODO for NAS: routine maintenance on music
# TODO add preservation whitelisted dirs and files

{ config, pkgs, ... }: {

  flake.homeModules.mpd = {
	  imports = [
	    ./beets/default.nix # organize library, tags
	    ./mpd-discord-rpc/default.nix # display playback on discord
      ./mpd-sima/default.nix # queue songs based on history
	    ./mpd-mpris/default.nix # mpris service
	    ./ncmpcpp/default.nix # classic tui client
	    ./rmpc/default.nix # new tui client
	    # ./cantata/default.nix # gui client
	    ./sptlrx/default.nix # tui for lyrics
	    ./mpdscribble/default.nix # scribble
	    ./wiremix/default.nix # pipewire mixer
	    ./zellij/default.nix # zellij layout for music
	  ];

    home.packages = [
      pkgs.mpc
      # wrap bpm-tag into bpm-calc, for rgbpm to use
      # it needs to load bpm into the shell alongside bpm-tag cause something, redirects help output to null
      (pkgs.writeShellScriptBin "bpm-calc" /*bash*/ ''
        exec ${pkgs.bpm-tools}/bin/bpm -h > /dev/null 2>&1
        exec ${pkgs.fd}/bin/fd -e mp2 -e mp3 -e flac -x ${pkgs.bpm-tools}/bin/bpm-tag -f'')
    ];

	  services.mpd = {
	    enable = true;
      # TODO reassign value if server is acting as host, connecting as client
      musicDirectory = "/mnt/NAS/Media/Music";
      playlistDirectory = "${config.services.mpd.musicDirectory}/playlists/";
      dbFile = "${config.home.homeDirectory}/.config/mpd/database";
      extraConfig = ''
      sticker_file "${config.home.homeDirectory}/.config/mpd/sticker.sql"
      log_file "${config.home.homeDirectory}/.config/mpd/log"

      audio_output { # foo output for visualizers, such as cava
        type "fifo"
        name "my_fifo"
        path "/tmp/mpd.fifo"
        format "44100:16:2"
      }

      audio_output { # pipewire output
        type "pipewire"
        name "PipeWire"
        format "384000:f:2"
      }

      replaygain "auto"
      max_output_buffer_size "16384"
      mixramp_analyzer "yes"
    '';
      extraArgs = [ "--verbose" ];
	  };

    home.shellAliases.newmusic = let
      sacad_r = "${pkgs.sacad}/bin/sacad_r";
      rgbpm = "${pkgs.loudgain}/bin/rgbpm";
    in "cd ${config.services.mpd.musicDirectory} && \
        beet import -q unsorted && \
        ${sacad_r} -i unsorted 1400 cover.jpg && \
        ${rgbpm} unsorted -q";

	  # set the mpd mixramp settings after build
	  # home.activation.mpd-mixramp-setup = lib.hm.dag.entryAfter ["installPackages"] ''
    #    ${pkgs.mpc}/bin/mpc mixrampdelay 1
    #    ${pkgs.mpc}/bin/mpc mixrampdb -12
    #  '';
  };

}
