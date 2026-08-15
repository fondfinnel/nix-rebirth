
{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    mainDir = "/service";
  in {
 
    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${mainDir}"
      "${mainDir}/tunarr"
    ];


    virtualisation.oci-containers.containers.tunarr = {
      image = "chrisbenincasa/tunarr";
      pull = "newer";
      ports = [
        "127.0.0.1:31111:8000" # redirect webui to port 31111, lan only
      ];

      # TODO dir
      volumes = [
        "${mainDir}/tunarr:/config/tunarr" # redirect config storage
      ];

      environment = {
        LOG_LEVEL = "INFO";
        TZ = config.time.timeZone;
        NVIDIA_VISIBLE_DEVICES = lib.mkIf config.hardware.nvidia.modesetting.enable "all";
      };

    };

  };


}
