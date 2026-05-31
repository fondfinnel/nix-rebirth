{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.services.mic-volume.enable = lib.mkEnableOption "mic-volume";
    config.services.mic-volume.enable = lib.mkDefault false;

    config.systemd.user.services.mic-volume = lib.mkIf config.services.mic-volume.enable {
      Unit.Description = "Keeps mic gain at 100%";
      Install.WantedBy = [ "default.target" ];

      Service.Type = "simple";
      Service.Restart = "always";
      Service.RestartSec = 5;
      Service.ExecStart = (pkgs.writeShellScript "mic-volume" /*bash*/
        ''exec ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ 100%'');
    };

  };


}
