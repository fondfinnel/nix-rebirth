{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.swayimg = {
      enable = lib.mkDefault check;

      # tried getting q to quit, no luck
      # might be updated api in the future though
      # on window resize, resets image to fit window
      initLua = /* lua */
        ''
            swayimg.viewer.set_default_scale("fit")
            swayimg.on_redrawn(
                swayimg.viewer.reset()
            )
        '';
    };

    xdg.mimeApps.defaultApplications = let x = "swayimg.desktop"; in lib.mkIf config.programs.swayimg.enable {
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
      "image/gif" = [x];
    };

    home.shellAliases.img = lib.mkIf config.programs.swayimg.enable "swayimg";

  };


}
