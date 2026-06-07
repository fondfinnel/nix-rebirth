{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.cantata.enable = lib.mkEnableOption "cantata";
    config.programs.cantata.enable = lib.mkDefault false;

    config.home.packages = lib.mkIf config.programs.cantata.enable [ pkgs.cantata ];


    config.xdg.configFile."Cantata/Cantata.conf" = {
      enable = config.programs.cantata.enable;

      text = lib.generators.toINI {} {
        General = {
          cdAuto = true;
          composerGenres = "Classical";
          contextAlwaysCollapsed = false;
          contextAutoScroll = true;
          contextBackdrop = 1;
          contextBackdropBlur=20;
          contextBackdropOpacity = 10;
          contextDarkBackground = true;
          contextSlimPage = "artist";
          contextSwitchTime = 0;
          contextTrackView = 0;
          coverFilename = "cover";
          cueSupport = "ignore";
          fetchCovers = true;
          forceSingleClick = true;
          hiddenPages= ["PlayQueuePage" "ContextPage"];
          # httpAllocatedPort = 41519;
          ignorePrefixes = "The";
          infoTooltips = true;
          inhibitSuspend = true;
          lyricProviders= [
            "letras.mus.br"
            "azlyrics.com"
            "chartlyrics.com"
            "lyrics.wikia.com"
            "genius.com"
            "musixmatch.com"
            "darklyrics.com"
            "directlyrics.com"
            "elyrics.net"
            "lololyrics.com"
            "lyrics.com"
            "lyricsdownload.com"
            "lyricsmania.com"
            "lyricsmode.com"
            "lyricsreg.com"
            "lyriki.com"
            "mp3lyrics.org"
            "songlyrics.com"
            "vagalume.com.br"
          ];
          maximized = false;
          minimiseOnClose = false;
          mpris = false;
          overwriteSongs = false;
          page = "PlaylistsPage";
          paranoiaFull = true;
          paranoiaNeverSkip = true;
          paranoiaOffset = 0;
          playQueueAutoExpand = true;
          playQueueBackground = 0;
          playQueueBackgroundBlur = 0;
          playQueueBackgroundOpacity = 20;
          playQueueConfirmClear = true;
          playQueueScroll = true;
          playQueueSearch = true;
          playQueueStartClosed = false;
          playQueueView = "grouped";
          playStream = false;
          responsiveSidebar = true;
          showCoverWidget = true;
          showDeleteAction = false;
          showFullScreen = false;
          showMenubar = false;
          showPlaylist = true;
          showPopups = false;
          showRatingWidget = true;
          showStopButton = false;
          showTechnicalInfo = true;
          showTimeRemaining = true;
          sidebar = 307;
          splitterAutoHide = false;
          startHidden = false;
          startupState = "prev";
          stopFadeDuration = 400;
          stopOnExit = false;
          storeCoversInMpdDir = true;
          storeLyricsInMpdDir = false;
          useCddb = true;
          useOriginalYear = true;
          useSystemTray = true;
          volumeStep = 5;
          wikipediaIntroOnly = true;
          wikipediaLangs = "en:en";
        };

        AlbumView.fullWidthCover = true;

        Connection-Default = {
          allowLocalStreaming = false;
          applyReplayGain = true;
          asciiOnly = false;
          autoUpdate = false;
          dir = config.services.mpd.musicDirectory;
          host = config.services.mpd.network.listenAddress;
          ignoreThe = false;
          port = config.services.mpd.network.port;
          replaceSpaces = false;
          replayGain = "auto";
          scheme = "%albumartist%/%album%/%track% %title%";
          vfatSafe = true;
        };

        CoverDialog.size = "@Size(779 785)";
        DynamicPlaylistsPage.viewMode = "list";

        LibraryPage = {
          "album\viewMode" = "detailedtree";
          albumSort = "year";
          "artist\searchActive" = true;
          "artist\viewMode" = "simpletree";
          artistImages = true;
          "genre\searchActive" = true;
          "genre\viewMode" = "detailedtree";
          grouping = "artist";
          librarySort = "year";
        };

        Scrobbling.enabled = false;

        Shortcuts-cantata = {
          randomplaylist = "Alt+S";
          showdevicestab = "Ctrl+5";
          showfolderstab = "Ctrl+2";
          showlibrarytab = "Ctrl+1";
          showonlinetab = "Ctrl+4";
          showplayliststab = "Ctrl+3";
          showsonginfo = "Ctrl+T";
        };

      };

    };

  };

}
