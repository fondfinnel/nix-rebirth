{ self, inputs, ... }: {

  flake.nixosConfigurations.nix-heaven = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.base
      self.nixosModules.disko-zfs-root
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
    # required for clean zfs exports
    networking.hostId = "d39654b5";

    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    services.greetd.enable = false;

    services.tuned.ppdSettings.main.default = "power-saver";
    services.tuned.ppdSettings.profiles = {
      balanced = "balanced";
      power-saver = "server-powersave";
      performance = "throughput-performance";
    };

    # upsd, nut, etc
    power.ups = {
      enable = true;
      mode = "netserver";
      ups.main = {
        description = "Cyber Power System, Inc. PR1500LCDRT2U UPS";

        # see docs for list of drivers
        # https://networkupstools.org/stable-hcl.html
        driver = "usbhid-ups";

        port = "auto";
        directives = [
          "offdelay = 60"
          "ondelay = 90"
          "lowbatt = 40"
          # "ignorelb"
        ];
      };
      upsmon.monitor.main.system = "main@localhost";
    };

    users.users.n0ll.linger = true;
    
    # needs work
    services.nfs.server = {
      enable = true;      
      lockdPort = 4001;
      mountdPort = 4002;
      statdPort = 4000;

      exports."/export/Personal"."192.168.50.101" = [
        "rw"
        "sync"
        "crossmnt"
        "no_subtree_check"
      ];

    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
      allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];
    };

    services.samba = let

      "read only" = "no";
      "guest ok" = "no";
      "valid users" = [
        "n0ll"
      ];
      "create mask" = "0644";
      "directory mask" = "0755";

    in {
      enable = true;
      openFirewall = true;
      settings.global.security = "user";
      # TODO add tailscale
      settings.global."usershare path" = "/var/lib/samba/usershares";
      # settings.global."hosts allow" = "192.168.50. 127.0.0.1 localhost";
      # settings.global."hosts deny" = "0.0.0.0/0";
      settings.global."guest account" = "nobody";
      settings.global."map to guest" = "bad user";
      settings.global."server smb encrypt" = "desired";
      settings.global."invalid users" = [
        "root"
      ];
      settings.personal = {
        inherit "read only" "guest ok" "valid users" "create mask" "directory mask";
        path = "/Primary/Personal";
      };

      settings.torrent = {
        inherit "read only" "guest ok" "valid users" "create mask" "directory mask";
        path = "/Primary/Torrent";
      };
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


    programs.rust-motd = {
      enable = true;
      settings = {
        weather.style = "oneline";
        service-status = {
          sanoid.unit = "sanoid";
        };
        uptime.prefix = "uptime";
        filesystems."Primary".mount-point = "/Primary";
        memory.swap-pos = "beside";
        last-login.num-logins = 3;
      };
    };


    virtualisation.containers.registries.settings.registry = [
      { location = "docker.io"; }
      { location = "quay.io"; }
      { location = "ghcr.io"; }
    ];

  };

  flake.nixosModules.nix-heaven-hw = { lib, config, pkgs, ... }: {

    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs = {
      forceImportRoot = true;
      extraPools = [ "Primary" "Apps" ];
    };

    disko.devices.disk.main.device = "/dev/nvme0n1";

    services.zfs.autoScrub = {
      enable = true;
      pools = [ "Primary" ];
      interval = "monthly";
    };

    
    fileSystems."/export/Personal" = {
      device = "/Primary/Personal";
      fsType = "none";
      options = [ "rbind" ];
    };

    # 4x32GB on host
    # 96GB max, 16GB min
    # Gibibytes to bytes
    # 1024^3 per GB
    # convert num to string
    # why no builtins.toPower? 
    boot.kernelPackages = pkgs.linuxPackages_6_18;
    boot.kernelParams = [
      "zfs.zfs_arc_max=${builtins.toString (96 * (1024 * 1024 * 1024))}"
      "zfs.zfs_arc_min=${builtins.toString (16 * (1024 * 1024 * 1024))}"
    ];


    };

}
