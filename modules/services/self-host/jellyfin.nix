# TODO cloudflared rules
# TODO other management tools
{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, self, ... }: let
    # TODO link it to zfs dataset location
    check = config.device-type == "server";
    mainDir = "/mnt/Apps";
    allDirs = [
      config.containers.jellyfin-container.bindMounts.app-data.hostPath
      config.containers.jellyfin-container.bindMounts.app-config.hostPath
    ];
  in {

    # imports = lib.mkIf check [
    # self.nixosModules.jellyfin-vue
    # ];

    # system.activationScripts.pre-015.deps = [ "specialfs" ];
    # system.activationScripts.pre-015.text = '' mkdir -p ${mainDir}/jellyfin/data ${mainDir}/config'';

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 1664 jellyfin media") allDirs;

    containers.jellyfin-container = {

      autoStart = true;
      ephemeral = false;

      bindMounts.app-data = {
        mountPoint = "/data";
        hostPath = "${mainDir}/jellyfin/data";
      };

      bindMounts.app-config = {
        mountPoint = "/config";
        hostPath = "${mainDir}/jellyfin/config";
      };

      config = { containerPkgs, ... }: {

        services.jellyfin = {
          enable = lib.mkDefault check;

          hardwareAcceleration.enable = lib.mkDefault true;
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
