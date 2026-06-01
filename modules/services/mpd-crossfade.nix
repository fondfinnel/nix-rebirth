{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: {

    options.programs.mpd-crossfade.enable = lib.mkEnableOption "mpd-crossfade";
    config.programs.mpd-crossfade.enable = lib.mkDefault check;

    systemd.user.services.mpd-crossfade = let
      check = (osConfig.device-type == "primary") == (config.services.mpd.enable == true);
    in lib.mkIf check {
      Unite.Description = "Crossfades track when not playing through an album.";
      Install.WantedBy = [ "default.target" ];

      Service.Restart = "always";
      Service.RestartSec = 10;

      Service.Type = "simple";
      Service.ExecStart = ( pkgs.writeShellScript "mpd-crossfade-service" /*bash*/
        let
          mpc = "${pkgs.mpc}/bin/mpc";
        in ''
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
            ${mpc} mixrampdelay 0
            echo "Disabled crossfade!"
            ${mpc} crossfade 0
          else
            ${mpc} mixrampdelay 1
            ${mpc} mixrampdb -12
            echo "Enabled crossfade!"
            ${mpc} crossfade 10
          fi
         '');
    };

  };


}
