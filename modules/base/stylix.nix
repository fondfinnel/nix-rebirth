{ self, inputs, config, ... }: {

  flake.nixosModules.base = { lib, config, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    #   stylix = {
    #     enable = lib.mkDefault true;
    #     autoEnable = lib.mkDefault true;

    #     base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    #   };
  };

  flake.homeModules.base = { lib, osConfig, ... }: {
    imports = [ inputs.stylix.homeModules.stylix ];

    # stylix.enable = lib.mkDefault osConfig.stylix.enable;
  };


}
