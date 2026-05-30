{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, config, lib, ... }: let
    face = config.home.file.".face".source;
  in{

    programs.fastfetch = lib.mkDefault {
      enable = true;

      settings = {
        logo.padding.right = 1;

        display.separator = "  ";

        modules = [ 
          "title"
          {
            type = "datetime";
            key = "Date";
            format = "{1}-{3}-{11}";
          }
          "uptime"
          
          "separator"
          
          "os"
          "kernel"
          "packages"
          "de"
          "wm"
          "terminal"
          "shell"

          "separator"

          "cpu"
          "gpu"
          "memory"
          "disk"
        ];
      };
    };

    home.shellAliases.fetch = lib.mkIf config.programs.fastfetch.enable "${pkgs.jp2a}/bin/jp2a --colors --height=15 ${face} | ${pkgs.fastfetch}/bin/fastfetch --logo - --processing-timeout 1";

  };


}
