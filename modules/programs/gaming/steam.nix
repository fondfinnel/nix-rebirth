{ self, inputs, config, ... }: let
  check = config.headless-check && config.high-performance;
in {

  flake.nixosModules.gaming = { lib, config, pkgs, ... }: {
    
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
      "${config.xdg.dataHome}/Steam"
      ".steam"
      ".cache/steam"
    ];
  };


}
