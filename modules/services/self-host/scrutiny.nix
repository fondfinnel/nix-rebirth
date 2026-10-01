{ self, inputs, config, ... }: {


  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {

    environment.systemPackages = [ pkgs.smartmontools ];

    services.scrutiny = {

      enable = true;
      openFirewall = true;

      settings = {
        web.listen.port = 9090;
      };
      
    };

  };


}
