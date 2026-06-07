{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

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
