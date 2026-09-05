{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    # TODO get dir
    mainDir = "/services/tubearchivist";
  in {

    sops.secrets."tubearchivist".name = "tubearchivist";
    sops.secrets."archivist-es".name = "archivist-es";
    
    # ensure dirs are available for containers
    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${mainDir}"
      "${mainDir}/youtube"
      "${mainDir}/cache"
      "${mainDir}/redis-data"
      "${mainDir}/elast-data"
    ];
    
    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
    virtualisation.oci-containers.containers.tubearchivist = {
      
      image = "docker.io/bbilly1/tubearchivist"; 
      pull = "newer";

      ports = [ "31000:8000" ];
      volumes = [
        "${mainDir}/youtube:/youtube"
        "${mainDir}/cache:/cache"
      ];

      environmentFiles = [ config.sops.secrets."tubearchivist".path ];

      dependsOn = [
        "tubearchivist-redis"
        "tubearchivist-es"
      ];

    };

    virtualisation.oci-containers.containers.tubearchivist-redis = {
      image = "docker.io/redis";
      pull = "newer";
      volumes = [ "${mainDir}/redis-data:/data" ];
      # ports = [ "127.0.0.1:31001:6379" ];
      dependsOn = [ "tubearchivist-es" ];
    };
    
    # may need to run on directory
    # chown 1000:0 -R /dir
    virtualisation.oci-containers.containers.tubearchivist-es = {
      image = "docker.io/bbilly1/tubearchivist-es";
      pull = "newer";
      volumes = [ "${mainDir}/elast-data:/usr/shared/elasticsearch/data" ];
      environmentFiles = [ config.sops.secrets."archivist-es".path ];
      # ports = [ "127.0.0.1:31002:9200" ];
    };

  };
}
