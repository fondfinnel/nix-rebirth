{ self, inputs, ... }: {

  flake.nixosConfigurations.nix-heaven = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.base
      self.nixosModules.nix-heaven-conf
      self.nixosModules.nix-heaven-hw
      self.nixosModules.ups
      self.nixosModules.users
      self.nixosModules.self-host
    ];
  };

  flake.nixosModules.nix-heaven-conf = { lib, config, pkgs, ... }: {

    networking.hostName = "nix-heaven";
    nixpkgs.hostPlatform = "x86_64-linux";

    device-type = "server";
    high-performance = true;
    headless-check = false;

    # head -c 8 /etc/machine-id
    networking.hostId = "d39654b5";

    power.ups = {
      enable = true;
      mode = "netserver";
      ups.main = {
        description = "Cyber Power System, Inc. PR1500LCDRT2U UPS";

        # see docs for list of drivers
        # https://networkupstools.org/stable-hcl.html
        driver = "usbhid-ups";

        port = "auto";
        directive = [
          "offdelay = 60"
          "ondelay = 90"
          "lowbatt = 40"
          # "ignorelb"
        ];
    services.samba = {
      enable = true;
      openFirewall = true;
      settings.global.security = "user";
      # TODO add tailscale
      settings.global."hosts allow" = "192.168.50. 127.0.0.1 localhost";
      settings.global."hosts deny" = "0.0.0.0/0";
      settings.global."guest account" = "nobody";
      settings.global."map to guest" = "bad user";
      settings.global."server smb encrypt" = "desired";
      settings.global."invalid users" = [
        "root"
      ];

      settings.personal = {
        path = "/mnt/Primary";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = [
          "n0ll"
        ];
        # TODO masks

      };
    };

    # broadcast share on LAN?>
    services.samba-wsdd.enable = false;
      };
    };

    services.samba = {
      enable = true;
      openFirewall = true;
      settings.global.security = "user";
      # TODO add tailscale
      settings.global."hosts allow" = "192.168.50. 127.0.0.1 localhost";
      settings.global."hosts deny" = "0.0.0.0/0";
      settings.global."guest account" = "nobody";
      settings.global."map to guest" = "bad user";
      settings.global."server smb encrypt" = "desired";
      settings.global."invalid users" = [
        "root"
      ];

      settings.personal = {
        path = "/mnt/Primary";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = [
          "n0ll"
        ];
        # TODO masks

      };
    };

    # broadcast share on LAN?>
    services.samba-wsdd.enable = false;

  };

  flake.nixosModules.nix-heaven-hw = { lib, config, pkgs, ... }: {

    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs = {
      forceImportRoot = true;
      extraPools = [ "Primary" ];
    };

    fileSystems."/" =
      { device = "/dev/by-label/temp";
        fsType = "ext4";
      };

    services.zfs.autoScrub = {
      enable = true;
      pools = [ "Primary" ];
      interval = "monthly";
    };

    services.sanoid = {
      enable = true;
      interval = "hourly";
      datasets."Primary" = {
        autosnap = true;
        autoprune = true;
        recursive = "zfs";
        hourly = 24;
        daily = 30;
        weekly = 8;
        monthly = 12;
      };
    };

    # 4x32GB on host
    # 96GB max, 16GB min
    # Gibibytes to bytes
    boot.kernelParams = [
      "zfs.zfs_arc_max=103079215104"
      "zfs.zfs_arc_min=17179869184"
    ];


  };



}
