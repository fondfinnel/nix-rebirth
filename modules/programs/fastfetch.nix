{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, config, ... }: let
    face = config.home.file.".face";
  in{

    programs.fastfetch = {

      enable = true;

      settings = {

        logo = { # specify logo itself on launch, more flexible
          padding = {
            right = 1;
          };
        };

        display = {
          separator = "  ";
        };

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

    home.shellAliases.fetch = "${pkgs.jp2a} --colors --height=15 ${face} | fastfetch --logo - --processing-timeout 1";

  };


}
