{ self, inputs, config, ... }: {

  flake.homeModules.qbittorrent = { lib, pkgs, config, osConfig, ... }: {

    options.programs.qbittorrent.enable = lib.mkEnableOption "qbittorrent";
    config.programs.qbittorrent.enable = lib.mkDefault (osConfig.headless-check && osConfig.high-performance);

    config.home = {
      packages = lib.mkIf config.programs.qbittorrent.enable [ pkgs.qbittorrent ];
      preserve.directories = [
        ".config/qBittorrent"
      ];

    };

  };


}
