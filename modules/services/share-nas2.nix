{ self, inputs, config, ... }: {

  flake.nixosModules.share-nas2 = { lib, config, pkgs, ... }: {

    boot.supportedFilesystems = [ "nfs" ];

    fileSystems."/mnt/NAS" = {
      device = "192.168.50.100:/Primary/Personal";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };

  };


}
