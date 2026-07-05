{ self, inputs, config, pkgs, ... }: let

  papedirectory =
    "/mnt/NAS/Media/Photos/DSLR/wallpaper";
  # "/mnt/NAS/Media/Photos/Wallpapers/anime-manga";
  # "/mnt/NAS/Media/Photos/Wallpapers";
  check = config.device-type == "primary";
  check2 = config.headless-check;

in {

  flake.homeModules.wpaperd = { pkgs, lib, ... }: let
    backuppape = pkgs.nixos-artwork.wallpapers.binary-black;
  in {
    
    services.wpaperd = {
      enable = lib.mkDefault check2;

      settings.any = {
        path = if check then papedirectory else backuppape;
        duration = if check then "5m" else "1h";
        mode = "center"; # use fit-border-color when it gets the next version
        sorting = "random";
      };  

    };

    # fix for wpaperd, see https://github.com/danyspin97/wpaperd/issues/117
    # would need fixed after lua rewrite
    wayland.windowManager.hyprland.settings.render.expand_undersized_textures = false; 
  };


}
