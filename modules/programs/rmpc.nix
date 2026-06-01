{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { config, lib, ... }: {
    programs.rmpc = {
      enable = lib.mkDefault config.services.mpd.enable;

      config = let
        mpd = config.services.mpd;
      in /* ron */ lib.mkDefault ''
        (
          address: "${builtins.toString mpd.network.listenAddress}:${builtins.toString mpd.network.port}",
          select_current_song_on_change: true,
          theme: Some("theme"),

          // keybinds: (
          //   navigation: {
          //     "<S-Enter>": AddAllReplace,
          //     "<Enter>": InsertAll, 
          //   }, 
          // ),

        )
      '';
    };


  };


}
