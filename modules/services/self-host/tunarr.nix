{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {
 
    virtualization.oci-containers.containers.tunarr = {
      image = "chrisbenincasa/tunarr";
      ports = [
        "127.0.0.1:31111:8000" # redirect webui to port 31111, lan only
      ];

      volumes = [
        "/mnt/Primary/Personal/Media/.service/tunarr:/config/tunarr" # redirect config storage
      ];

      environment = {
        LOG_LEVEL = "INFO";
      } ++ lib.optionals (config.hardware.nvidia.modesetting.enable == true) {
        NVIDIA_VISIBLE_DEVICES = "all";
      };

      dependsOn = [ "jellyfin" ];
    };

  };


}
