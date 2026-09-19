{ self, inputs, config, ... }: {


  flake.nixosModules.qbittorrent-container = { lib, config, pkgs, ... }: let
    mainDir = "/services/qbittorrent";
    torrentMount = "/Primary/Torrent";
  in {

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${mainDir}"
      "${mainDir}/data"
      "${mainDir}/vpn"
      "${mainDir}/qui"
    ];

    virtualisation.oci-containers.containers.qui = {

      image = "ghcr.io/autobrr/qui:latest";
      pull = "newer";

      ports = [
        "30012:7476" 
      ];

      volumes = [
        "${mainDir}/qui:/config" # redirect config storage
        "${torrentMount}:${torrentMount}"
      ];

      environment = {
        TZ = config.time.timeZone;
      };

    };


    networking.nat.enable = true;
    networking.nat.internalInterfaces = [ "ve-qbittorrent" ];

    containers.qbittorrent = {

      autoStart = true;
      ephemeral = false;

      hostAddress = "192.168.100.1";
      
      localAddress = "192.168.100.2";

      privateNetwork = true;
      forwardPorts = [{
        containerPort = 8080;
        hostPort = 30011;
        protocol = "tcp";
      }];

      enableTun = true;

      bindMounts.app-data = {
        isReadOnly = false;
        mountPoint = "/var/lib/qBittorrent";
        hostPath = "${mainDir}/data";
      };

      bindMounts.app-vpn = {
        isReadOnly = false;
        mountPoint = "/var/lib/tailscale";
        hostPath = "${mainDir}/vpn";
      };

      bindMounts.torrent = {
        isReadOnly = false;
        # matches mount for qui
        mountPoint = torrentMount;
        hostPath = torrentMount;
      };
      

      config = {containerPkgs, pkgs, ... }: {

        networking.useHostResolvConf = false;
        services.resolved.enable = true;
        networking.firewall.allowedTCPPorts = [ 80 ];

        services.qbittorrent = {
          enable = true;
          openFirewall = true;
          extraArgs = [ "--confirm-legal-notice" ];
          webuiPort = 8080;
          profileDir = "/var/lib/qBittorrent";

          #   serverConfig.Preferences = {
          #     "WebUI/HostHeaderValidation" = false;
          #     "WebUI/CSRFProtection" = false;            
          #     "WebUI/AuthSubnetWhitelistEnabled" = true;
          #     "WebUI/AuthSubnetWhitelist" = "192.168.50.0/24";
          #     "Advanced/RecheckOnCompletion" = true;
          #   };

          #           serverConfig.BitTorrent = {
          #     "Session\AlternativeGlobalDLSpeedLimit" = 500;
          #     "Session\AlternativeGlobalUPSpeedLimit" = 1;
          #     "Session\AnonymousModeEnabled" = false;
          #     "Session\BandwidthSchedulerEnabled" = false;
          #     "Session\DisableAutoTMMByDefault" = false;
          #     "Session\GlobalDLSpeedLimit" = 2000;
          #     "Session\GlobalMaxInactiveSeedingMinutes" = 0;
          #     "Session\GlobalMaxRatio" = 0;
          #     "Session\GlobalMaxSeedingMinutes" = 0;
          #     "Session\GlobalUPSpeedLimit" = 1;
          #     # "Session\Interface" = "enp39s0";
          #     # "Session\InterfaceName" = "enp39s0";
          #     "Session\Port" = 7650;
          #     "Session\QueueingSystemEnabled" = false;
          #     "Session\SSL\Port" = 20093;
          #     "Session\StartPaused" = false;
          #     "Session\TempPathEnabled" = false;
          #     "Session\TorrentContentLayout" = "Subfolder";
          #   };
        };

        services.tailscale = {
          enable = lib.mkDefault true; 
          extraSetFlags = [ # Sets launch options for tailscaled
            "--accept-routes"
            "--exit-node=100.117.167.110" # For Mullvad, choosing which exit node to use. Needs to be an actual IP or else tailscaled-set complains at boot.
            # To find another mullvad node, run `tailscale exit-node <list/suggest>`
            "--exit-node-allow-lan-access=true"
          ];
          useRoutingFeatures = "client";
        };

      };

    };

  };

}
