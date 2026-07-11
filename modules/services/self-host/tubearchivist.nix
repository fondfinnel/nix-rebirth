{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    # TODO get dir
    mainDir = "/path/to/dir";
  in {

    sops.secrets."tubearchivist".name = "tubearchivist";
    sops.secrets."archivist-es".name = "archivist-es";
    
    virtualisation.oci-containers.containers.tubearchivist = {

      image = "bbilly1/tubearchivist"; 

      ports = [ "31000:8000" ];
      volumes = [
        "${mainDir}/youtube:/youtube"
        "${mainDir}/cache:/cache"
      ];

      environmentFiles = [ config.sops.secrets."tubearchivist".path ];

      dependsOn = [
        "archivist-redis"
        "archivist-es"
      ];

    };

    virtualisation.oci-containers.containers.archivist-redis = {
      image = "dhi.io/redis";
      volumes = [ "${mainDir}/redis-data:/data" ];
      ports = [ "127.0.0.1:31001:6379" ];
      dependsOn = [ "archivist-es" ];
    };
    
    # may need to run on directory
    # chown 1000:0 -R /dir
    virtualisation.oci-containers.containers.archivist-es = {
      image = "bbilly1/tubearchivist-es";
      volumes = [ "${mainDir}/elast-data:/usr/shared/elasticsearch/data" ];
      ports = [ "127.0.0.1:31002:9200" ];
    };

  };
}
