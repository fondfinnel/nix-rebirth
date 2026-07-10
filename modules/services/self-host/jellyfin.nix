# TODO cloudflared rules
# TODO other management tools
{ self, inputs, config, ... }: let
  check = config.device-type == "server";
in {

  flake.nixosModules.self-host = { lib, config, self, ... }: let
    # TODO link it to zfs dataset location
    mainDir = "/mnt/Apps";
  in {

    imports = lib.mkIf check [
      # self.nixosModules.jellyfin-vue
    ];

    containers.jellyfin-container = {

      autoStart = true;
      ephemeral = false;

      config = { containerPkgs, ... }: {

        services.jellyfin = {
          enable = lib.mkDefault check;

          hardwareAcceleration.enable = lib.mkDefault true;
          hardwareAcceleration.type = "qsv";

          dataDir = "${mainDir}/jellyfin/data";
          configDir = "${mainDir}/jellyfin/config";
          # uses port 8096, does not have option for that yet

          transcoding = lib.mkDefault {
            enableHardwareEncoding = true;
            hardwareEncodingCodecs = {
              av1 = true;
              hevc = true;
            };

            enableHardwareDecoding = true;
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
    virtualization.oci-containers.containers.jellyfin-vue = {
      image = "jellyfin/jellyfin-vue";

      ports = [
        "30014:80"
      ];

      dependsOn = [ "jellyfin" ];
    };

  };

}
