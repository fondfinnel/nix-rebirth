
{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    mainDir = "/services/tunarr";
  in {
 
    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${mainDir}"
      "${mainDir}/config"
    ];


    virtualisation.oci-containers.containers.tunarr = {
      image = "docker.io/chrisbenincasa/tunarr";
      pull = "newer";
      ports = [
        "31111:8000" # redirect webui to port 31111, lan only
      ];

      devices = [
        "/dev/dri:/dev/dri"
      ];

      # TODO dir
      volumes = [
        "${mainDir}/config:/config/tunarr" # redirect config storage
        "/Primary/Personal/Media:/Media:ro" # read only for media
      ];

      environment = {
        LOG_LEVEL = "INFO";
        TZ = config.time.timeZone;
        NVIDIA_VISIBLE_DEVICES = lib.mkIf config.hardware.nvidia.modesetting.enable "all";
      };

    };

  };


}
