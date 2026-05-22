{ self, inputs, ... }: {


  flake.homeModules.noctalia-shell = { pkgs, lib, config, ... }: {

    options.cust.noctalia-shell.enable = lib.mkEnableOption "noctalia-shell";
    
    config.systemd.user.services.noctalia-shell = lib.mkIf config.cust.noctalia-shell {
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

