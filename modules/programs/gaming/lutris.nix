{ self, inputs, config, ... }:  {

  flake.homeModules.gaming = { lib, pkgs, osConfig, config, ... }: let
    check = osConfig.high-performance && osConfig.headless-check;
  in {

    programs.lutris = {

      enable = lib.mkDefault check;
      package = pkgs.lutris;

      extraPackages = with pkgs; lib.mkIf config.programs.lutris.enable [
        mangohud
        gamescope
        gamemode
      ];

      steamPackage = osConfig.programs.steam.package;

    };

    home.preserve.directories = lib.mkIf config.programs.lutris.enable [ "Games" ];

  };

}
