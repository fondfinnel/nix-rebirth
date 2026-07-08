{ self, inputs, config, ... }: {

  flake.nixosModules.gaming = { lib, config, pkgs, ... }: let
    check = config.headless-check && config.high-performance;
  in {
    
    programs.steam = {
      enable = lib.mkDefault check;
      remotePlay.openFirewall = lib.mkDefault check;
      dedicatedServer.openFirewall = lib.mkDefault check;
    };
    hardware.steam-hardware.enable = lib.mkDefault check;

    programs.gamemode.enable = lib.mkDefault check;

  };

  flake.homeModules.gaming = { lib, osConfig, config, pkgs, ... }: {
    home.preserve.directories = lib.mkIf osConfig.programs.steam.enable [
      ".local/share/Steam"
      ".steam"
      ".cache/steam"
    ];
  };


}
