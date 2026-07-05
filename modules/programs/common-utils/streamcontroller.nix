{ self, inputs, config, ... }:  {

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check && osConfig.high-performance;
  in {

    options.services.streamcontroller.enable = lib.mkEnableOption "streamcontroller";
    config.services.streamcontroller.enable = lib.mkDefault false;

    config.home.packages = lib.mkIf config.services.streamcontroller.enable [ 
      pkgs.streamcontroller
      pkgs.python313Packages.streamcontroller-plugin-tools
    ]; 

    config.systemd.user.services.streamcontroller = lib.mkIf config.services.streamcontroller.enable {
      Unit.Description = "Control Elgato Stream Deck";
      Install.WantedBy = [ "default.target" ];

      Service = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 1;
        ExecStart = "${pkgs.writeShellScript "streamcontroller-service" /*bash*/ ''
        ${pkgs.streamcontroller}/bin/streamcontroller -b  
      ''}";
      };
    };

    config.home.preserve.directories = lib.mkIf config.services.streamcontroller.enable [ ".var/app/com.core447.StreamController" ];

  };


}
