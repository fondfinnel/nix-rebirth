{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {
    
    programs.yt-dlp = {
      enable = lib.mkDefault true;
      settings = lib.mkDefault {
        update = true;
        embed-subs = true;
      };
    };

  };

}
