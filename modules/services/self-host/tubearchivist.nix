{ self, inputs, config, ... }: {

  flake.nixosModules.tube = { lib, config, pkgs, ... }: let
    # TODO get dir
    mainDir = "/home/n0ll/tube";
  in {

    sops.secrets."tubearchivist".name = "tubearchivist";
    sops.secrets."archivist-es".name = "archivist-es";
    
    # ensure dirs are available for containers
    systemd.tmpfiles.rules = lib.map (f: "d ${f} 1664 tubearchivist media") [
      "${mainDir}/youtube"
      "${mainDir}/cache"
      "${mainDir}/redis-data"
      "${mainDir}/elast-data"
    ];
    
    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
    virtualisation.oci-containers.containers.tubearchivist = {
      
      image = "bbilly1/tubearchivist"; 
      pull = "newer";

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
      image = "redis";
      pull = "newer";
      volumes = [ "${mainDir}/redis-data:/data" ];
      # ports = [ "127.0.0.1:31001:6379" ];
      # dependsOn = [ "archivist-es" ];
    };
    
    # may need to run on directory
    # chown 1000:0 -R /dir
    virtualisation.oci-containers.containers.archivist-es = {
      image = "bbilly1/tubearchivist-es";
      pull = "newer";
      volumes = [ "${mainDir}/elast-data:/usr/shared/elasticsearch/data" ];
      environmentFiles = [ config.sops.secrets."archivist-es".path ];
      # ports = [ "127.0.0.1:31002:9200" ];
    };

  };
}
