{ self, inputs, config, pkgs, ... }: {

  flake.homeModules.wpaperd = { pkgs, lib, config, osConfig, ... }: let
    backuppape = pkgs.nixos-artwork.wallpapers.binary-black;
    papedirectory =
      # "/mnt/NAS/Media/Photos/DSLR/wallpaper";
      "/mnt/NAS/Media/Photos/Wallpapers/anime-manga";
    # "/mnt/NAS/Media/Photos/Wallpapers";
    check2 = osConfig.headless-check;
  in {
    
    services.wpaperd = {
      enable = lib.mkDefault check2;

      settings.any = {
        path = if osConfig.device-type == "primary" then papedirectory else backuppape;
        duration = if osConfig.device-type == "primary" then "5m" else "1h";
        mode = "center"; # use fit-border-color when it gets the next version
        sorting = "random";
      };  

    };

    # fix for wpaperd, see https://github.com/danyspin97/wpaperd/issues/117
    # would need fixed after lua rewrite
    wayland.windowManager.hyprland.settings.render.expand_undersized_textures = false; 
  };


}
