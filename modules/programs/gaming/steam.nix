{ self, inputs, config, ... }: {

  flake.nixosModules.gaming = { lib, config, pkgs, ... }: {
    
    programs.steam = {
      enable = lib.mkDefault true;
      remotePlay.openFirewall = lib.mkDefault true;
      dedicatedServer.openFirewall = lib.mkDefault true;
    };
    hardware.steam-hardware.enable = lib.mkDefault true;

    programs.gamemode.enable = lib.mkDefault true;

  };


}
