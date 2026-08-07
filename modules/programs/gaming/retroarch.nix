{ self, inputs, config, ... }: {

  flake.homeModules.gaming = { pkgs, config, osConfig, lib, ... }: {

    programs.retroarch = {
      enable = lib.mkDefault (osConfig.headless-check && osConfig.high-performance);

      cores = {
        swanstation.enable = true;
        snes9x.enable = true;
        pcsx2.enable = true;
        ppsspp.enable = true;
      };

      settings = {
        netplay_nickname = config.home.username;
        video_fullscreen = "true";
      };
      
    };

  };


}
