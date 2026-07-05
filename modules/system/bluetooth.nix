{ self, inputs, ... }: {

  flake.nixosModules.bluetooth = { lib, config, ... }: {

    hardware.bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault config.hardware.bluetooth.enable;
    };
    services.blueman.enable = lib.mkDefault config.hardware.bluetooth.enable;

    environment.preserve.directories = [ "/var/lib/bluetooth" ];

    home-manager.sharedModules = [ self.homeModules.bluetooth ];

  };

  flake.homeModules.bluetooth = { pkgs, osConfig, lib, ... }: lib.mkIf osConfig.hardware.bluetooth.enable {

    home.packages = [
      pkgs.bluetui
    ];

    services.mpris-proxy.enable = true; 

  };

}
