{ self, inputs, ... }: {
  flake.nixosModules.nix-solid-hw = { pkgs, lib, config,... }: {

    boot.initrd.availableKernelModules = [ "nvme" "ahci" "firewire_ohci" "xhci_pci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
    boot.initrd.kernelModules = [ "dm-snapshot" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    boot.initrd.systemd.fido2.enable = true;


    boot.loader.limine.enable = true;

    boot.initrd.luks.devices.enc-bt = {
      device = "/dev/disk/by-uuid/91471cb2-e390-47ff-a8cd-8995a75a67b4";
      preLVM = true;
      allowDiscards = true;
      fido2.passwordLess = true;
      crypttabExtraOpts = [ "fido2-device=auto" ];
    };

    boot.initrd.luks.devices.enc-hm = {
      device = "/dev/disk/by-uuid/f4fb151f-8b86-4553-aaa9-023518e537a8";
      preLVM = true;
      allowDiscards = true;
      fido2.passwordLess = true;
      crypttabExtraOpts = [ "fido2-device=auto" ];
    };

    fileSystems."/" =
      { device = "/dev/mapper/bt-root";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/5574-F849";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };

    fileSystems."/home" =
      { device = "/dev/mapper/hm-home";
        fsType = "ext4";
      };

    swapDevices = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  };  
}
