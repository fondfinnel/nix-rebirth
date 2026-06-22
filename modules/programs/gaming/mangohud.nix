{ self, inputs, config, ... }: let
  check = config.headless-check && config.high-performance;
in {

  flake.homeModules.gaming = { lib, config, ... }: {

    programs.mangohud = let s = config.programs.mangohud.settings; in {  
      enable = lib.mkDefault check;

      settings = {
        background_color = lib.mkDefault 020202;
        background_alpha = lib.mkDefault 0.4;
        font_size = lib.mkDefault 14;
        position = lib.mkDefault "top-right";
        round_corners = lib.mkDefault 1;
        media_player_name = lib.mkDefault "mpd-mpris";
      };

      # share default settings across apps, however alter position
      settingsPerApplication = {
        "wine-Gunfire Reborn" = s // { position = "top-center"; };
        "wine-helldivers2" = s // { position = "middle-left"; };
        "wine-MonsterHunterWilds" = s // { position = "middle-right"; };
        "wine-Planetside2_x64" = s // { position = "bottom-right"; };
        "wine-Risk of Rain 2" = s // { position = "middle-right"; };
        "wine-RoboQuest-Win64-Shipping" = s // { position = "top-left"; };
      };
  };

  };


}
