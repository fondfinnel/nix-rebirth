{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.cantata.enable = lib.mkEnableOption "cantata";
    config.programs.cantata.enable = lib.mkDefault false;

    config.home.packages = lib.mkIf config.programs.cantata.enable [ pkgs.cantata ];


    config.xdg.configFile."Cantata/Cantata.conf" = {
      enable = config.programs.cantata.enable;

      text = ''        
      [General]
      cdAuto=true
      cddbHost=gnudb.gnudb.org
      cddbPort=80
      composerGenres=Classical
      contextAlwaysCollapsed=false
      contextAutoScroll=true
      contextBackdrop=1
      contextBackdropBlur=20
      contextBackdropFile=
      contextBackdropOpacity=10
      contextDarkBackground=true
      contextSlimPage=artist
      contextSplitterState="@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x3\0\0\x1;\0\0\x1;\0\0\x1;\x1\0\0\0\0\x1\0\0\0\x1\0)"
      contextSwitchTime=0
      contextTrackView=0
      coverFilename=cover
      cueSupport=ignore
      currentConnection=Default
      fetchCovers=true
      forceSingleClick=true
      hiddenPages=PlayQueuePage, ContextPage
      hiddenStreamCategories=@Invalid()
      httpAllocatedPort=41519
      ignorePrefixes=The
      infoTooltips=true
      inhibitSuspend=true
      lang=
      lyricProviders=letras.mus.br, azlyrics.com, chartlyrics.com, lyrics.wikia.com, genius.com, musixmatch.com, darklyrics.com, directlyrics.com, elyrics.net, lololyrics.com, lyrics.com, lyricsdownload.com, lyricsmania.com, lyricsmode.com, lyricsreg.com, lyriki.com, mp3lyrics.org, songlyrics.com, vagalume.com.br
      mainWindowCollapsedSize=@Size(1900 1042)
      mainWindowPos=@Point(1286 30)
      mainWindowSize=@Size(1900 1036)
      maximized=false
      minimiseOnClose=false
      mpris=false
      overwriteSongs=false
      page=PlaylistsPage
      paranoiaFull=true
      paranoiaNeverSkip=true
      paranoiaOffset=0
      playQueueAutoExpand=true
      playQueueBackground=0
      playQueueBackgroundBlur=0
      playQueueBackgroundFile=
      playQueueBackgroundOpacity=20
      playQueueConfirmClear=true
      playQueueScroll=true
      playQueueSearch=true
      playQueueStartClosed=false
      playQueueView=grouped
      playStream=false
      responsiveSidebar=true
      showCoverWidget=true
      showDeleteAction=false
      showFullScreen=false
      showMenubar=false
      showPlaylist=true
      showPopups=false
      showRatingWidget=true
      showStopButton=false
      showTechnicalInfo=true
      showTimeRemaining=true
      sidebar=307
      singleTracksFolders=@Invalid()
      splitterAutoHide=false
      splitterState=@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x2\0\0\x1\x93\0\0\x5\xe4\x1\0\0\0\x1\x1\0\0\0\x1\0)
      startHidden=false
      startupState=prev
      stopFadeDuration=400
      stopOnExit=false
      storeCoversInMpdDir=true
      storeLyricsInMpdDir=false
      style=
      useCddb=true
      useOriginalYear=true
      useSystemTray=true
      version=2.5.0
      volumeStep=5
      wikipediaIntroOnly=true
      wikipediaLangs=en:en

      [AlbumDetailsDialog]
      size=@Size(800 600)

      [AlbumView]
      fullWidthCover=true

      [Connection-Default]
      allowLocalStreaming=false
      applyReplayGain=true
      asciiOnly=false
      autoUpdate=false
      dir=${config.services.mpd.musicDirectory}
      host=${config.services.mpd.network.listenAddress}
      ignoreThe=false
      partition=default
      passwd=
      port=${builtins.toString config.services.mpd.network.port}
      replaceSpaces=false
      replayGain=auto
      scheme=%albumartist%/%album%/%track% %title%
      streamUrl=
      transcoderCodec=
      transcoderValue=0
      transcoderWhen=0
      vfatSafe=true

      [CoverDialog]
      size=@Size(779 785)

      [CustomActions]

      [DevicesPage]
      gridZoom=100
      searchActive=false
      viewMode=simpletree

      [DynamicPlaylistsPage]
      gridZoom=100
      searchActive=true
      viewMode=list

      [FolderPage]
      currentPage=mpdbrowse

      [HttpStream]
      volume=50

      [LibraryPage]
      album\gridZoom=100
      album\searchActive=true
      album\viewMode=detailedtree
      albumSort=year
      artist\gridZoom=100
      artist\searchActive=true
      artist\viewMode=simpletree
      artistImages=true
      genre\gridZoom=100
      genre\searchActive=true
      genre\viewMode=detailedtree
      grouping=artist
      librarySort=year

      [MpdBrowsePage]
      gridZoom=100
      searchActive=false
      viewMode=simpletree

      [OnlineServicesPage]
      currentPage=streams

      [PlayQueuePage]
      searchActive=false

      [PlaylistRulesDialog]
      size=@Size(722 517)

      [PlaylistsPage]
      currentPage=dynamic

      [PodcastSearchDialog]
      size=@Size(800 600)

      [PodcastSettingsDialog]
      size=@Size(550 160)

      [PodcastWidget]
      gridZoom=100
      searchActive=false
      viewMode=detailedtree

      [PreferencesDialog]
      size=@Size(908 722)

      [Proxy]
      hostname=
      mode=0
      password=
      port=8080
      type=3
      username=

      [RgDialog]
      size=@Size(528 385)

      [Scrobbling]
      enabled=false
      loveEnabled=false
      scrobbler=Last.fm
      sessionKey=
      userName=

      [SearchPage]
      gridZoom=100
      searchActive=true
      searchCategory=file
      viewMode=list

      [Shortcuts-cantata]
      randomplaylist=Alt+S
      showdevicestab=Ctrl+5
      showfolderstab=Ctrl+2
      showlibrarytab=Ctrl+1
      showonlinetab=Ctrl+4
      showplayliststab=Ctrl+3
      showsonginfo=Ctrl+T

      [SmartPlaylistsPage]
      gridZoom=100
      searchActive=false
      viewMode=list

      [StoredPlaylistsPage]
      gridZoom=100
      searchActive=false
      startClosed=true
      viewMode=detailedtree

      [StreamsBrowsePage]
      gridZoom=100
      searchActive=false
      viewMode=detailedtree

      [SyncDialog]
      size=@Size(680 680)

      [TrackOrganiser]
      size=@Size(800 500)

      [VolumeControl]
      control=mpd

      [jamendo]
      albumSort=album
      gridZoom=100
      grouping=genre
      librarySort=year
      searchActive=false
      viewMode=detailedtree

      [localbrowsehome]
      gridZoom=100
      searchActive=false
      viewMode=simpletree

      [localbrowseroot]
      gridZoom=100
      searchActive=false
      viewMode=simpletree

      [magnatune]
      albumSort=album
      gridZoom=100
      grouping=genre
      librarySort=year
      searchActive=false
      viewMode=detailedtree

      [playQueue]
      tableHeader="@ByteArray(P,\x95\x1f\x1\0\0\0\x10\0\0\0\"\0\0\0\0\0\0\x2\xc3\0\0\x1,\0\0\0\xfb\0\0\0\x31\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x9e\0\0\0\0\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x3\0\0\0\x1\0\0\0\x4\0\0\0\x2\0\0\0\r\0\0\0\x5\0\0\0\x6\0\0\0\a\0\0\0\b\0\0\0\t\0\0\0\n\0\0\0\v\0\0\0\f\0\0\0\xe\0\0\0\xf\0\0\0\x10\0\0\0\x82\0\0\0\x82\0\0\0\x81\0\0\0\x81\0\0\0\x81\0\0\0\x81\0\0\0\x82\0\0\0\x82\0\0\0\x81\0\0\0\x82\0\0\0\x81\0\0\0\x81\0\0\0\x81\0\0\0\x84\0\0\0\x81\0\0\0\x81\0\0\0\0\0\0\0\x10?\x97\xa8!\xcb\x9d\xfeP\0\0\0\0\0\0\0\0?\xde\x33^\xa0\x35\xf\xdb?\xc9\xabk\xb9\xb0\xfd\x64?\xc5i1V\x93\x15i?\xa0g\xb8\xf9\x8b\xe5\x8b\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\xba\xeb\x66n\xf6(\xab\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0)"

      [playlist]
      tableHeader="@ByteArray(P,\x95\x1f\x1\0\0\0\f\0\0\0\xa8\0\0\0\x46\0\0\0O\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0P\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\f\0\0\0\0\0\0\0\x1\0\0\0\x2\0\0\0\x3\0\0\0\x4\0\0\0\x5\0\0\0\x6\0\0\0\a\0\0\0\b\0\0\0\t\0\0\0\n\0\0\0\v\0\0\0\f\0\0\0\x81\0\0\0\x81\0\0\0\x81\0\0\0\x82\0\0\0\x82\0\0\0\x81\0\0\0\x82\0\0\0\x81\0\0\0\x81\0\0\0\x81\0\0\0\x81\0\0\0\x81\0\0\0\0\0\0\0\f?\xdb(\n\x11-'\xbc?\xc6\xa7\x8f\xedy-{?\xc9Xl\x9bX^\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\xc9\xaf\xefT\xd4%\x5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0)"
    '';

    };

  };

}
