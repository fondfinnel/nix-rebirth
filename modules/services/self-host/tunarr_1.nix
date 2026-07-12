{ self, inputs, config, ... }: {

  flake.nixosModules.tunarr = { lib, config, pkgs, ... }: {
 
    virtualisation.oci-containers.containers.tunarr = {
      image = "chrisbenincasa/tunarr:latest";
      pull = "newer";
      # cmd = ["--restart=unless-stopped" ];
      ports = [
        "127.0.0.1:31111:8000" # redirect webui to port 31111, lan only
      ];

      # TODO dir
      volumes = [
        "/home/n0ll/tunarr:/config/tunarr" # redirect config storage
      ];

      environment = {
        LOG_LEVEL = "INFO";
        TZ = config.time.timeZone;
        NVIDIA_VISIBLE_DEVICES = lib.mkIf config.hardware.nvidia.modesetting.enable "all";
      };

      # dependsOn = [ "jellyfin" ];
    };

  };


}
