{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.lsd = {
      enable = lib.mkDefault true;

      settings = lib.mkDefault {
        date = "relative";
        color.when = "auto";
        layout = "tree";
        size = "short";
        sorting.dir-grouping = "first";
        total-size = true;
        hyperlink = "auto";
      };
    };

    home.shellAliases = lib.mkDefault {
      ls = "lsd";
      l = "lsd --header -l";
      tree = "lsd --tree --depth 2";
    };

  };


}
