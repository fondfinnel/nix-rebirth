{ self, inputs, config, ... }: let
  check = config.device-type == "server";
in {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {
    
    services.homepage-dashboard = {
      enable = lib.mkDefault check;
      listenPort = 8082;

      # Bookmark entries need to be surrounded with [{}]
      # homepage complains about 0.0.0.0
      # TODO list entries within other modules
      bookmarks = [ # /etc/homepage-dashboard/bookmarks.yaml
        {
          Media = [
            { "Youtube"     = [{ abbr = "yt"; href = "https://youtube.com"; }]; }
            { "YT Music"    = [{ abbr = "ym"; href = "https://music.youtube.com"; }]; }
            { "Bandcamp"    = [{ abbr = "hc"; href = "https://bandcamp.com"; }]; }
            { "Musicbrainz" = [{ abbr = "mb"; href = "https://musicbrainz.org"; }]; }
          ];
        }
        {
          Social = [
            { "Twitter"   = [{ abbr = "tw"; href = "https://twitter.com"; }]; }
            { "last.fm" = [{ abbr = "lf"; href = "https://last.fm/user/natervader13"; }]; }
            { "Reddit"    = [{ abbr = "rd"; href = "https://reddit.com"; }]; }
            { "Anilist"   = [{ abbr = "al"; href = "https://anilist.co"; }]; }
          ];
        }
        {
          Fourtune = let ft = "https://4chan.org/"; in [
            { "Technology"             = [{ abbr = "g";   href = "${ft}g"; }]; }
            { "Videogames"             = [{ abbr = "v";   href = "${ft}v"; }]; }
            { "Videogames General"   = [{ abbr = "vg";  href = "${ft}vg"; }]; }
            { "Photography"            = [{ abbr = "p";   href = "${ft}p"; }]; }
            { "Music"                  = [{ abbr = "mu";  href = "${ft}mu"; }]; }
            { "Wallpapers General"   = [{ abbr = "wg";  href = "${ft}wg"; }]; }
            { "Wallpapers Anime"     = [{ abbr = "w";   href = "${ft}w"; }]; }
            { "Fitness"                = [{ abbr = "fit"; href = "${ft}fit"; }]; }
          ];
        }
        {
          Docs = [
            { "NixOS Wiki"     = [{ abbr = "nw";  href = "https://nixos.wiki"; }]; }
            { "NixOS Packages" = [{ abbr = "np";  href = "https://search.nixos.org/packages"; }]; }
            { "MyNixOS"        = [{ abbr = "mno"; href = "https://mynixos.com"; }]; }
            { "Github"         = [{ abbr = "gh";  href = "https://github.com"; }]; }
            { "Codeberg"       = [{ abbr = "cb";  href = "https://codeberg.org"; }]; }
          ];
        }
        {
          Gaming = [
            { "Steam"            = [{ abbr = "ste";  href = "https://steampowered.com"; }]; }
            { "ProtonDB"         = [{ abbr = "pdb"; href = "https://protondb.com"; }]; }
            { "Good Old Games"   = [{ abbr = "gog"; href = "https://gog.com"; }]; }
            { "Epic Games Store" = [{ abbr = "egs"; href = "https://store.epicgames.com"; }]; }
            { "Humble"           = [{ abbr = "hb";  href = "https://humblebundle.com"; }]; }
            { "IsThereAnyDeal"   = [{ abbr = "id";  href = "https://isthereanydeal.com"; }]; }
          ];
        }
        {
          "Storage and Networking" = [
            { "Storj"     = [{ abbr = "sj"; href = "https://us1.storj.io/login"; }]; }
            { "Synchthing" = [{ abbr = "sti"; href = config.services.syncthing.guiAddress; }]; }
            { "Tailscale" = [{ abbr = "ts";   href = "https://login.tailscale.com/admin/machines"; }]; }
          ];
        }
        {
          "PC Building" = [
            { "Bottleneck Calc"   = [{ abbr = "bc";  href = "https://pc-builds.com/bottleneck-calculator"; }]; }
            { "PCPartPicker"      = [{ abbr = "ppp"; href = "https://pcpartpicker.com"; }]; }
            { "Power Supply Calc" = [{ abbr = "psc"; href = "https://outervision.com/power-supply-calculator"; }]; }
          ];
        }
      ];
  };

  };


}
