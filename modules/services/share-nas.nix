{ self, inputs, config, ... }: {

  flake.nixosModules.share-nas = { lib, config, pkgs, ... }: let
    automount_opts = [
      "x-systemd.automount" # have sysmd handle mount and reduce issues of hanging filesystem
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "noauto"
      "async"
      "exec"
      "user"
      "users"
      "nofail"
      "x-systemd.requires=network-online.target"
      # "vers=3.0"
      "uid=1000"
      "gid=100"
      "_netdev"
      "credentials=${config.sops.secrets."smb/cred".path}"
    ];
    nas_ip = "nate-truenas"; # TODO sops
  in {
    
    environment.systemPackages = [ pkgs.cifs-utils ];

    sops.secrets = let
      owner = config.users.users.n0ll.name;
      group = config.users.users.n0ll.group;
    in {
      "smb/cred" = {
        inherit owner group;
        neededForUsers = true;
        path = "${config.users.users.n0ll.home}/.smbcredentials";
        mode = "0440";
      };
      "smb/ip" = {
        inherit owner group;
      };
    };
    
    # Mount the share on boot
    fileSystems."/mnt/NAS" = {
      device = "//${nas_ip}/Primary";
      fsType = "cifs";
      options = automount_opts;
    };

    # no longer around... keeping just in case
    fileSystems."/mnt/Torrent" = {
      device = "//${nas_ip}/Torrent";
      fsType = "cifs";
      options = automount_opts;
    };

    # Tune firewall for CIFS
    networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

    home-manager.sharedModules = [self.homeModules.share-nas];

  };

  flake.homeModules.share-nas = { config, lib, ... }: {

    home.activation.symNAS = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
       run ln -sfn "/mnt/NAS" "${config.home.homeDirectory}/NAS"
       run ln -sfn "/mnt/Torrent" "${config.home.homeDirectory}/Torrent"
    ''; 

  };


}
