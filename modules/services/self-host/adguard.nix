{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    check = config.device-type == "server";
  in {

    services.adguardhome = {
      enable = lib.mkDefault false;
      mutableSettings = lib.mkDefault false;
      # host = "192.158.50.100";
      port = 3000;
      settings = {
        theme = "dark";
        dns = {
          upstream_dns = [
            "1.1.1.1"
          ];
          bind_hosts = [ "192.168.50.100" ];
          bootstrap_dns = [ "192.168.50.1" ];
          # ratelimit = 0;
          cache_enabled = true;
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
        };
        # The following notation uses map
        # to not have to manually create {enabled = true; url = "";} for every filter
        # This is, however, fully optional
        filters = map(url: { enabled = true; url = url; }) [
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"  # The Big List of Hacked Malware Web Sites
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"  # malicious url blocklist
          "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt"
        ];
      };
    };

  };

}
