{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    check = config.device-type == "server";
  in {

    # podman's aardvark conflicts with other network dns filters
    virtualisation.podman.defaultNetwork.settings.network.dns_port = 2525;

    services.adguardhome = {
      enable = lib.mkDefault false;
      mutableSettings = lib.mkDefault true;
      # host = "192.158.50.100";
      port = 3000;
      settings = {
        theme = "dark";
        dns = {
          upstream_dns = [
            "1.1.1.1"
          ];
          bind_hosts = [ "0.0.0.0" ];
          # ratelimit = 0;
          cache_enabled = true;
        };
      };
    };

  };

}
