{ self, inputs, config, ... }: let
  check = config.headless-check == config.high-performance;
in {

  flake.nixosModules.default = { lib, ... }: {

    # base nixpkgs creates setcap wrapper, otherwise prompts sudo when running
    programs.gpu-screen-recorder.enable = lib.mkDefault check;

  };

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: let
    check2 = config.programs.gpu-screen-recorder.enable == osConfig.programs.gpu-screen-recorder.enable;
  in {

    options.programs.gpu-screen-recorder.enable = lib.mkEnableOption "gpu-screen-recorder";
    config.programs.gpu-screen-recorder.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf check [ pkgs.gpu-screen-recorder ];
    config.home.shellAliases.cap = lib.mkIf check2 "killall -SIGUSR1 gpu-screen-recorder ; kitten notify 'Clip saved'";

    config.systemd.user.services.gpu-screen-recorder = lib.mkIf check2 {
      Unit.Description = "Record the primary display in the background and save clips to user's ~/Videos.";
      Install.WantedBy = [ "default.target" ];

      Service.Restart = "always";
      Service.RestartSec = 1;
      Service.ExecStart = (pkgs.writeShellScript "gpu-screen-recorder-service" /*bash*/ ''
        exec ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder \
          -w screen \
          -f 60 \
          -r 120 \
          -a 'default_input|default_output' \
          -c mp4 \
          -o ${config.xdg.userDirs.videos}
      '');
    };

  };

}
