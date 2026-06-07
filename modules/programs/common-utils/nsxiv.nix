{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.nsxiv.enable = lib.mkEnableOption "nsxiv";
    config.programs.nsxiv.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.nsxiv.enable [ pkgs.nsxiv ];
    config.xdg.mimeApps.defaultApplications =
      let x = "nsxiv.desktop"; in
      lib.mkIf config.programs.nsxiv.enable lib.mkDefault
        {
          "image/png" = [x];
          "image/jpg" = [x];
          "image/jpeg" = [x];
          "image/jp2" = [x];
          "image/cr2" = [x];
          "image/webp" = [x];
          "image/bmp" = [x];
          "image/apng" = [x];
          "image/tiff" = [x];
          "image/avif" = [x];
          "image/heif" = [x];
          "image/x-canon-cr2" = [x];
          "image/x-ruji-raf" = [x];
        };

  };


}
