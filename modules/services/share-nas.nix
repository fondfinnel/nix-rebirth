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
    nas_ip = "192.168.50.100"; # TODO sops
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
      device = "//${nas_ip}/personal";
      fsType = "cifs";
      options = automount_opts;
    };

    # no longer around... keeping just in case
    fileSystems."/mnt/Torrent" = {
      device = "//${nas_ip}/torrent";
      fsType = "cifs";
      options = automount_opts;
    };

    # Tune firewall for CIFS
    networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

    # create service for each user's home to store symlinks for share
    home-manager.sharedModules = [ self.homeModules.share-nas ];

  };

  flake.homeModules.share-nas = { osConfig, config, lib, pkgs, ... }: {

    systemd.user.services.nas-symlink = lib.mkIf osConfig.fileSystems."/mnt/NAS".enable {
      Unit.Description = "Symlink network attach storage directories in user's home";
      Install.WantedBy = [ "default.target" ];

      Service.Type = "oneshot";
      Service.RemainAfterExit = true;
      Service.ExecStart = ( pkgs.writeShellScript "share-nas-service" /*bash*/
        ''
         ln -sfn "${osConfig.fileSystems."/mnt/NAS".mountPoint}" "${config.home.homeDirectory}/NAS"
         ln -sfn "${osConfig.fileSystems."/mnt/Torrent".mountPoint}" "${config.home.homeDirectory}/Torrent"
        ''
      );  

    };

  };


}
