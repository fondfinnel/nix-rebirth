{
  self,
  inputs,
  config,
  ...
}:
{

  flake.nixosModules.self-host =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      check = config.device-type == "server";
    in
    {

      # expose the dns to lan
      networking.firewall.allowedTCPPorts = [ 53 ];
      networking.firewall.allowedUDPPorts = [ 53 ];

      services.adguardhome = {
        enable = lib.mkDefault check;
        mutableSettings = lib.mkDefault false;
        # openFirewall = true;
        settings = {
          theme = "dark";
          http.address = "0.0.0.0:3000";
          dns = {
            upstream_dns = [
              "1.1.1.1"
              # "9.9.9.9#dns.quad9.net"
            ];
            bind_hosts = [ "192.168.50.100" ];
            bootstrap_dns = [ "1.1.1.1" ];
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
          filters =
            map
              (url: {
                enabled = true;
                url = url;
              })
              [
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
                "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt"
              ];
        };
      };

    };

}
