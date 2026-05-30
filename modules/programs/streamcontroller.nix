{ self, inputs, config, ... }: let
  check = config.headless-check == config.high-performance;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.streamcontroller.enable = lib.mkEnableOption "streamcontroller";
    config.programs.streamcontroller.enable = lib.mkDefault false;

    config.home.packages = lib.mkIf config.programs.streamcontroller.enable [ 
      pkgs.streamcontroller
      pkgs.python313Packages.streamcontroller-plugin-tools
    ]; 

    config.systemd.user.services.streamcontroller = lib.mkIf config.programs.streamcontroller.enable {
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

  };


}
