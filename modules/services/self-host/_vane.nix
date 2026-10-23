{ self, inputs, config, ... }: {


  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "/services/vane"
    ];


    virtualisation.oci-containers.containers.vane = {

      image = "docker.io/itzcrazykns1337/vane:latest";
      pull = "newer";

      ports = [
        "11120:3000" # redirect webui to port 31111, lan only
      ];

      # TODO dir
      volumes = [
        "/services/vane:/home/vane/data" # redirect config storage
      ];

      environment = {
        TZ = config.time.timeZone;
      };

    };



  };


}
