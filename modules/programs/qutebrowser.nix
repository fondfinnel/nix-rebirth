{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.qutebrowser = {
      enable = lib.mkDefault false;
      settings = {
        completion.height = "15%";
        content.autoplay = false;
        colors.webpage = {
          preferred_color_scheme = "dark";
          darkmode.enabled = true;
        };
      };
      quickmarks = {
        server = "local.nate.server";
      };
    };

  };


}
