{ self, inputs, config, ... }: {

  flake.nixosModules.gaming = { lib, config, pkgs, ... }: let
    check = config.headless-check && config.high-performance;
    check2 = config.programs.steam.enable;
  in {
    
    programs.steam = {
      enable = lib.mkDefault check;
      remotePlay.openFirewall = lib.mkDefault check2;
      dedicatedServer.openFirewall = lib.mkDefault check2;
    };
    hardware.steam-hardware.enable = lib.mkDefault check2;

    programs.gamemode.enable = lib.mkDefault check2;

  };

  flake.homeModules.gaming = { lib, osConfig, config, pkgs, ... }: {
    home.preserve.directories = lib.mkIf osConfig.programs.steam.enable [
      ".local/share/Steam"
      ".steam"
      ".cache/steam"
      ".config/unity3d"
    ];
  };


}
