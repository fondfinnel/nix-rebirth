{ self, inputs, config, ... }: let
  enabled = config.headless-check;
in {


  flake.homeModules.noctalia-shell = { pkgs, lib, ... }: {

    
    config.systemd.user.services.noctalia-shell = lib.mkIf enabled {
      Unit.Description = "Noctalia shell.";
      Install.WantedBy = [ "default.target" ];

      Service = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 5;
        ExecStart = (pkgs.writeShellScript "noctalia-shell-start" /*bash*/ ''
        ${pkgs.noctalia-shell}/bin/noctalia-shell -n  
      '');
      };
    };

  };

}

