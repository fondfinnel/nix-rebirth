{ self, inputs, config, ... }: {


  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "/services/ollama/serve"
      "/services/ollama/webui"
    ];


    virtualisation.oci-containers.containers.open-webui = {

      image = "ghcr.io/open-webui/open-webui:main";
      pull = "newer";

      ports = [
        "11150:8080" # redirect webui to port 31111, lan only
      ];

      # TODO dir
      volumes = [
        "/services/ollama/webui:/app/backend/data" # redirect config storage
      ];

      environment = {
        TZ = config.time.timeZone;
      };

    };


    # let podman deal with the networking
    # I could not  get native nixpkgs to work
    virtualisation.oci-containers.containers.ollama = {

      image = "docker.io/ollama/ollama:latest";
      pull = "newer";

      ports = [
        "11434" # redirect webui to port 31111, lan only
      ];

      # TODO dir
      volumes = [
        "/services/ollama/serve:/root/.ollama" # redirect config storage
      ];


      # devices = [
      #   "/dev/dri:/dev/dri"
      # ];

      environment = {
        TZ = config.time.timeZone;
      };

    };


  };


}
