{ self, inputs, config, ... }: {

  flake.homeModules.mopidy = { pkgs, config, lib, ... }: {

    services.mopidy = {
      enable = lib.mkDefault config.services.mpd.enable == false;
      settings = {
        file.media_dirs = [
          config.services.mpd.musicDirectory
        ];
      };
      extensionPackages = with pkgs.mopidyPackages; [
        mopidy-mpd
        mopidy-local
        mopidy-somafm
        mopidy-ytmusic
        mopidy-mpris
      ];
    };

    services.mpd-discord-rpc.enable = lib.mkDefault config.programs.vesktop.enable;
  };


}
