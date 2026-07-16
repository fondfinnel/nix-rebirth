{ self, inputs, config, ... }: {

  flake.nixosModules.disko-preservation = { pkgs, lib, config, ... }: {

    imports = [
      inputs.disko.nixosModules.disko
    ];

    preservation.enable = true;

    fileSystems."/persist".neededForBoot = true;
    fileSystems."/nix".neededForBoot = true;
    # fileSystems."/etc/ssh".neededForBoot = true;
    
    
    disko.devices.nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "size=50%" "mode=755" ];
    };

    # mostly rewritten from https://haseebmajid.dev/posts/2024-07-30-how-i-setup-btrfs-and-luks-on-nixos-using-disko/
    disko.devices.disk.main = {

      # define the device itself
      type = "disk";

      content = {

        # set up the boot partition
        type = "gpt";

        partitions.boot = {
          name = "boot";
          size = "1M";
          type = "EF02";
        };

        partitions.esp = {
          name = "ESP";
          size = "1G";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };

        # define the root partition under luks encrypt
        partitions.luks = {
          
          size = "100%";
          label = "luks";

          # luks part contains what?
          # located in /dev/mapper
          content = {
            type = "luks";
            name = "cryptroot";

            extraOpenArgs = [
              "--allow-discards"
              "--perf-no_read_workqueue"
              "--perf-no_write_workqueue"
            ];

            settings.crypttabExtraOpts = [
              "fido2-device=auto"
              "token-timeout=5"
            ];

            # the unencrypted data
            content = let

              # define shared mountOptions
              n = [ "compress=zstd" "noatime" ];

            in {
              type = "btrfs";
              extraArgs = [  "-f" ];

              subvolumes = {

                "/nix".mountpoint = "/nix";
                "/nix".mountOptions = [ "subvol=nix" ] ++ n;

                "/persist".mountpoint = "/persist";
                "/persist".mountOptions = [ "subvol=persist" ] ++ n;

              };

            };

          };

        };

      };

    };

  };

}
