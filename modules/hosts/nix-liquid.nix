{ self, inputs, ... }: {

  # Import modules as if root of flake
  flake.nixosConfigurations.nix-liquid = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.base
      self.nixosModules.nix-liquid-conf
      self.nixosModules.nix-liquid-hw

      self.nixosModules.bluetooth 
    ];

  };

  # Most changes for system here
  flake.nixosModules.nix-liquid-conf = { pkgs, lib, config, ... }: {

    networking.hostName = "nix-liquid";
    nixpkgs.hostPlatform = "x86_64-linux";

    device-type = "primary";

    boot.loader.limine = {
      enable = true;
      additionalFiles = { "efi/memtest86/memtest86.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi"; };
      extraEntries =
        "/memtest86
        protocol: chainload
        path: boot():///efi/memtest86/memtest86.efi
      ";
    };
    boot.loader.efi.canTouchEfiVariables = true;

    hardware.keyboard.zsa.enable = true;
    hardware.keyboard.qmk.enable = true;

    home-manager.sharedModules = [
      { services.mic-volume.enable = true; }
    ];

    imports = [
      self.nixosModules.users
    ];

  };

  # Changes from hardware-configuration.nix
  flake.nixosModules.nix-liquid-hw = { pkgs, lib, config,... }: {

    imports = [

      # declare partition scheme
      self.nixosModules.nix-liquid-disko

      self.nixosModules.nix-liquid-preserve

    ];

  };  

  flake.nixosModules.nix-liquid-disko = { pkgs, lib, config, ... }: {

    imports = [
      inputs.disko.nixosModules.disko
      self.nixosModules.preservation-default
    ];
    preservation.enable = true;

    # mostly rewritten from https://haseebmajid.dev/posts/2024-07-30-how-i-setup-btrfs-and-luks-on-nixos-using-disko/
    disko.devices.disk = {

      nvme0n1 = {

        # define the device itself
        type = "disk";
        device = "/dev/sda";

        content = {

          # set up the boot partition
          type = "gpt";
          partitions.ESP = {
            label = "boot";
            name = "ESP";
            size = "512M";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "defaults" ];
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
                  extraArgs = [ "-L" "nixos" "-f" ];

                  subvolumes = {
                    "/root".mountpoint = "/";
                    "/root".mountOptions = [ "subvol=root" ] ++ n;

                    "/home".mountpoint = "/home";
                    "/home".mountOptions = [ "subvol=home" ] ++ n;

                    "/nix".mountpoint = "/nix";
                    "/nix".mountOptions = [ "subvol=nix" ] ++ n;

                    "/persist".mountpoint = "/persist";
                    "/persist".mountOptions = [ "subvol=persist" ] ++ n;
                    
                    "/log".mountpoint = "/var/log";
                    "/log".mountOptions = [ "subvol=log" ] ++ n;

                    "/swap".mountpoint = "/swap";
                    "/swap".swap.swapfile.size = "8G";
                  };

                };

              };

            };

          };

        };

      };

      fileSystems."/persist".neededForBoot = true;
      fileSystems."/var/log".neededForBoot = true;
    }

  };

}
