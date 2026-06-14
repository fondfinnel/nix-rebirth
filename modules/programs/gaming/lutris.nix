{ self, inputs, config, ... }: let
  check = config.high-performance == config.headless-check;
in {

  flake.homeModules.gaming = { lib, pkgs, osConfig, config, ... }: {

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

    home.persistence."/persistent".directories = [ "Games" ];

  };

}
