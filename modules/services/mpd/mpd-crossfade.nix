{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: {

    config.services.mpd.extraConfig = lib.mkIf config.programs.mpd-crossfade.enable ''mixramp_analyzer "yes"'';

    options.programs.mpd-crossfade.enable = lib.mkEnableOption "mpd-crossfade";
    config.programs.mpd-crossfade.enable = lib.mkDefault check;

    config.systemd.user.services.mpd-crossfade = let
      check = (osConfig.device-type == "primary") == (config.services.mpd.enable == true);
    in lib.mkIf check {
      Unite.Description = "Crossfades track when not playing through an album.";
      Install.WantedBy = [ "default.target" ];

      Service.Restart = "always";
      Service.RestartSec = 10;

      Service.Type = "simple";
      Service.ExecStart = let
        mpc = "${pkgs.mpc}/bin/mpc";
        restartTime = builtins.toString config.systemd.user.services.mpd-crossfade.Service.RestartSec;
      in ( pkgs.writeShellScript "mpd-crossfade-service" /*bash*/
        ''
          if [ $(${mpc} status %state%) != "playing" ]; then
            exit
          fi

          a1="$(${mpc} current -f %album%)"
          t1="$(${mpc} current -f %track%)"
          echo "curr: $t1 of $a1"

          a2="$(${mpc} queued -f %album%)"
          t2="$(${mpc} queued -f %track%)"
          echo "next: $t2 of $a2"

          let x=$t2
          let y=x-1

          if [ "$a1" == "$a2" ] && [ $t1 -eq $y ]; then
            # ${mpc} mixrampdelay 0
            echo "Disabled crossfade!"
            ${mpc} crossfade 0
          else
            # ${mpc} mixrampdelay 1
            # ${mpc} mixrampdb -10
            ${mpc} crossfade ${restartTime}
            echo "Enabled crossfade!"
          fi
         '');
    };

  };


}
