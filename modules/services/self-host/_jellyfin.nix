# TODO cloudflared rules
# TODO add route rules for jellyfin, lock out lan for service
# TODO other management tools
{ self, inputs, config, ... }: {

  flake.nixosModules.jellyfin-container = { lib, config, self, ... }: let
    # TODO link it to zfs dataset location
    mainDir = "/path/to/dir";
    allDirs = [
      config.containers.jellyfin-container.bindMounts.app-data.hostPath
      config.containers.jellyfin-container.bindMounts.app-config.hostPath
    ];
  in {

    # imports = lib.mkIf check [
    # self.nixosModules.jellyfin-vue
    # ];

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${mainDir}"
      "${mainDir}/data"
      "${mainDir}/config"
    ];


    networking.nat.enable = true;
    networking.nat.internalInterfaces = [ "ve-jellyfin" ];

    containers.jellyfin = {

      autoStart = true;
      ephemeral = false;

      hostAddress = "192.168.100.1";
      
      localAddress = "192.168.100.2";

      privateNetwork = true;
      forwardPorts = [{
        containerPort = 8096;
        hostPort = 31010;
        protocol = "tcp";
      }];

      enableTun = true;

      bindMounts.app-data = {
        isReadOnly = false;
        mountPoint = "/data";
        hostPath = "${mainDir}/data";
      };

      bindMounts.app-config = {
        isReadOnly = false;
        mountPoint = "/config";
        hostPath = "${mainDir}/config";
      };

      bindMounts.gpu = {
        isReadOnly = false;
        mountPoint = "/dev/dri";
        hostPath = "/dev/dri";
      };

      bindMounts.media = {
        isReadOnly = true;
        mountPoint = "/media";
        hostPath = "/home/n0ll/Videos";
      };

      tmpfs = [
        "/var"
        "/tmp"
      ];
      
      config = { containerPkgs, pkgs, ... }: {

        environment.systemPackages = [ pkgs.mesa pkgs.vulkan-loader ];
        networking.firewall.enable = true;
        networking.firewall.allowedTCPPorts = [ 8096 ];

        networking.useHostResolvConf = false;
        services.resolved.enable = true;

        users.users.n0ll.isNormalUser = true;

        services.jellyfin = {
          enable = lib.mkDefault true;

          hardwareAcceleration.enable = lib.mkDefault true;
          hardwareAcceleration.device = "/dev/dri";
          hardwareAcceleration.type = "qsv";

          dataDir = "/data";
          configDir = "/config";
          # uses port 8096, does not have option for that yet

          transcoding = lib.mkDefault {
            enableHardwareEncoding = true;
            hardwareEncodingCodecs = {
              av1 = true;
              hevc = true;
            };

            hardwareDecodingCodecs = let x = true; in {
              vp9 = x;
              vp8 = x;
              vc1 = x;
              mpeg2 = x;
              hevc = x;
              hevcRExt10bit = x;
              hevcRExt12bit = x;
              h264 = x;
              av1 = x; 
            };
          };
        };
      };

    };

  };

  flake.nixosModules.jellyfin-vue = { lib, config, pkgs, ... }: {

    # alt webgui in development
    # probably will not use
    virtualisation.oci-containers.containers.jellyfin-vue = {
      image = "jellyfin/jellyfin-vue";

      ports = [
        "30014:80"
      ];

      dependsOn = [ "jellyfin" ];
    };

  };

}
