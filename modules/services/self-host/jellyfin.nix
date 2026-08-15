
{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    mainDir = "/service/jellyfin";
  in {
 
    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 1000 1000") [
      "${mainDir}"
      "${mainDir}/config"
      "${mainDir}/cache"
    ];


    virtualisation.oci-containers.containers.jellyfin = {
      image = "ghcr.io/jellyfin/jellyfin";
      pull = "newer";
      ports = [
        "127.0.0.1:31010:8096" 
        "127.0.0.1:7359:7359" 
      ];

      devices = [
        "/dev/dri:/dev/dri"
      ];

      # TODO dir
      volumes = [
        "${mainDir}/config:/config" # redirect config storage
        "${mainDir}/cache:/cache" # redirect cache storage
        "/home/n0ll/Videos:/media"
      ];

      environment = {
        LOG_LEVEL = "INFO";
        TZ = config.time.timeZone;
        NVIDIA_VISIBLE_DEVICES = lib.mkIf config.hardware.nvidia.modesetting.enable "all";
        PUID = "1000";
        GUID = "1000";
      };

    };

  };


}
