{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.nixosModules.common-utils = { lib, config, pkgs, ... }: {

    services.flatpak.enable = lib.mkDefault false;

    xdg.portal.extraPortals = lib.mkDefault [ pkgs.xdg-desktop-portal-gtk ];
    xdg.portal.config.common.default = lib.mkIf config.services.flatpak.enable "gtk";

  };


}
