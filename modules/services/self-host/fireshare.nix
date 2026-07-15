{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    # TODO dir
    mainDir = "/path/to/dir";
  in {

    sops.secrets."fireshare".name = "fireshare";

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 1664 fireshare media") [
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
