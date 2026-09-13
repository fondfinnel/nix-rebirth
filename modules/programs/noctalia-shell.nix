{ self, inputs, config, ... }: {


  flake.homeModules.noctalia-shell = { osConfig, pkgs, lib, ... }:  let
    enabled = osConfig.headless-check;
  in {
    
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

