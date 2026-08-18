{ self, inputs, config, ... }: {

  flake.nixosModules.disko-zfs-root = { lib, config, pkgs, ... }:
    {

      disko.devices =
        {
          disk.root =
            {

              type = "disk";
              device = "/dev/nvme0n1";
              content =
                {

                  partitions.ESP =
                    {
                      size = "1G";
                      type = "EF00";
                      content =
                        {
                          type = "filesystem";
                          format = "vfat";
                          mountpoint = "/boot";
                          mountOptions = [ "nofail" ];
                        };
                    };

                  partitions.zroot =
                    {
                      size = "100%";
                      content.type = "zfs";
                      content.pool = "zroot";
                    };

                };

            };
          disk.zpool.zroot =
            {
              type = "zpool";
              rootFsOptions =
                {
                  mountpoint = "none";
                  compression = "zstd";
                  acltype = "posixacl";
                  xattr = "sa";
                  "com.sun:auto-snapshot" = "true";
                };

              options.ashift = "12";
              datasets."root" =
                {
                  type = "zfs_fs";
                  options =
                    {
                      encryption = "aes-256-gcm";
                      keyformat = "passphrase";
                      # keylocation = "file:///path/to/secret";
                      keylocation = "prompt";
                    };
                  mountpoint = "/";
                };

              datasets."root/nix" =
                {
                  type = "zfs_fs";
                  options.mountpoint = "/nix";
                  mountpoint = "/nix";
                };

              # no swap, zfs does not support and too risky for my taste

            };
        };

    };


}
