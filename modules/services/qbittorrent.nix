{ self, inputs, config, ... }: {


  flake.nixosModules.qbittorrent-container = { lib, config, pkgs, ... }: let
    mainDir = "/services/qbittorrent";
  in {

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${mainDir}"
      "${mainDir}/data"
    ];


    networking.nat.enable = true;
    networking.nat.internalInterfaces = [ "ve-jellyfin" ];

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

      bindMounts.torrent = {
        isReadOnly = false;
        # matches mount for qui
        mountPoint = "/Primary/Torrent";
        hostPath = "/Primary/Torrent";
      };

      config = {containerPkgs, pkgs, ... }: {

        services.qbittorrent = {
          enable = true;
          extraArgs = [ "--confirm-legal-notice" ];
          webuiPort = 8080;
          profileDir = "/var/lib/qBittorrent";
        };
        
      };
    };

  };


}
