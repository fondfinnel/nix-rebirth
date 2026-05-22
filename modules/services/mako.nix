{ self, inputs, ... }: {
  flake.homeModules.mako = { lib, ... }: {

    services.mako = {
      enable = true;
      settings = {
        max-icon-size = lib.mkDefault "32";
        default-timeout = lib.mkDefault "5000";
        max-visible = lib.mkDefault "3";
        width = lib.mkDefault "300";
        height = lib.mkDefault "150";
        group-by = lib.mkDefault "category";
        layer = lib.mkDefault "overlay";
      };
    };

  };
}
