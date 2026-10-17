{ self, inputs, config, ... }: {

  flake.nixosModules.share-nas2 = { lib, config, pkgs, ... }: {

    boot.supportedFilesystems = [ "nfs" ];

    fileSystems."/mnt/test" = {
      device = "192.168.50.100:/export/Personal";
      fsType = "nfs4";
      options = [ "x-systemd.automount" "noauto" ];
    };

  };


}
