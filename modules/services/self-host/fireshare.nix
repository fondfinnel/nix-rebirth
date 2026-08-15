{ self, inputs, config, ... }: {

  flake.nixosModules.fireshare = { lib, config, pkgs, ... }: let
    # TODO dir
    mainDir = "/services/fireshare";
  in {

    sops.secrets."fireshare" = {};

    # fireshare configured for other uid gid
    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 1000 100") [
      # j"${mainDir}"
      "${mainDir}/data"
      "${mainDir}/processed"
      "${mainDir}/videos"
      "${mainDir}/images"
    ];

    virtualisation.oci-containers.containers.fireshare = {
      image = "shaneisrael/fireshare";
      ports = [
        # untested
        "127.0.0.1:1337:80"
      ];

      user = "root";

      volumes = [
        # TODO get dirs
        "${mainDir}/data:/data"
        "${mainDir}/processed:/processed"
        "${mainDir}/videos:/videos"
        "${mainDir}/images:/images"
      ];

      environmentFiles = [ config.sops.secrets."fireshare".path ];

    };

  };


}
