{ self, inputs, config, ... }: {

  # TODO colors
  # TODO lockscreen
  # TODO file imports
  flake.nixosModules.qtile = { lib, config, pkgs, ... }: let
    # myBackground = ../assets/evangelion-fear.jpg;
    color.LightGreen = "#33ff00";
    color.DarkGreen = "#2C8C1F";
    color.LightPurple = "#711F8C";
    color.DarkPurple = "#523874";
    color.Black = "#1F1D1C";
    color.Text = "#f6f5f4";
    myCursor = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      # size = 24;
      # sizeStr = "24";
    };
  in {

    services.xserver.windowManager.qtile = {
      enable = true;
      package = pkgs.qtile-unwrapped;
      extraPackages = p: with p; [ qtile-extras ];
    };

    # uncomment for wayland
    # nixpkgs.overlays = [
    #   (self: super: {
    #     qtile-unwrapped = super.qtile-unwrapped.overrideAttrs(_: rec {
    #       postInstall = let
    #         qtileSession = ''
    #         [Desktop Entry]
    #         Name=Qtile Wayland
    #         Comment=Qtile on Wayland
    #         Exec=qtile start -b wayland
    #         Type=Application
    #         '';
    #         in
    #         ''
    #           mkdir -p $out/share/wayland-sessions
    #           echo "${qtileSession}" > $out/share/wayland-sessions/qtile.desktop
    #         '';
    #       passthru.providedSessions = [ "qtile" ];
    #     });
    #   })
    # ];
    # services.displayManager.defaultSession = "qtile";
    # services.displayManager.sessionPackages = [ pkgs.qtile-unwrapped ];



    # TODO clean up
    environment.systemPackages = with pkgs; [
      flameshot # screenshots
      picom # extra effects such as blur
      rofi # x11 launcher
      kitty # terminal in my config
      feh
      (writeShellScriptBin "qtile-autostart" /*shell*/ ''
      udiskie &
      yams &
      keepassxc &
      streamcontroller -b &
      qbittorrent &
      # xrandr --output DisplayPort-2 --primary # assign primary display
      # xrandr --output HDMI-A-0 --left-of DisplayPort-2 & # fix display positions
      gpu-screen-recorder -w screen -f 60 -r 600 -a 'default_output|default_input' -c mp4 -o ~/Videos &
      # feh --bg-fill ${myBackground} & # wallpaper defined in qtile.nix
      # qtile cmd-obj --object cmd --function restart
      sleep 20 &
      steam -silent &
      vesktop --disable-gpu --start-minimized &
    '')
    ];

    fonts.packages = [ pkgs.hackgen-nf-font ];
    qt.platformTheme = "gtk2";
    environment.variables = { # various env variables to share with config.py
      # MYBACKGROUND = myBackground;
      # ZELLIJ_MUSIC = ../home/programs/zellij/music.kdl;
      MYCOLORLIGHTGREEN = color.LightGreen;
      MYCOLORDARKGREEN = color.DarkGreen;
      MYCOLORLIGHTPURPLE = color.LightPurple;
      MYCOLORDARKPURPLE = color.DarkPurple;
      MYCOLORBACKGROUND = color.Black;
      MYCOLORTEXT = color.Text;
    };

    # TODO clean up
    home-manager.sharedModules = [{
      imports = [
        # ./configs/home/dunst.nix
        # ./configs/home/picom.nix
      ];    
      gtk.theme.name = "fluent";
      gtk.theme.package = pkgs.fluent-gtk-theme;
      gtk.iconTheme.name = "oomox-gruvbox-dark";
      gtk.iconTheme.package = pkgs.gruvbox-dark-icons-gtk;
      qt.platformTheme.name = "gtk";
      qt.enable = true;
      gtk.enable = true;
      # Set cursor
      home.pointerCursor = {
        gtk.enable = true;
        package = myCursor.package;
        # size = myCursor.size;
        name = myCursor.name;
      };
      # Rofi config
      programs.rofi = {
        enable = true;
        theme = "gruvbox-dark-hard";
      };
      services.dunst.settings.global = {
        width = 200;
        transparency = 20;
        frame_color = color.LightPurple;
        background = color.Black;
        line_height = 8;
        max_icon_size = 32;
        font = "Hackgen35 Console NF 9";
      };
      programs.kitty = {
        themeFile = "Duotone_Dark";
        font = {
          package = pkgs.hackgen-nf-font;
          name = "Hackgen35 Console NF";
          size = 9;
        };
      };
      programs.helix.settings.theme = "base16_terminal";
    }];
    # end of home

    services.xserver.windowManager.qtile.configFile = let
      rofi = "${pkgs.rofi}/bin/rofi";
      kitty = "${pkgs.kitty}/bin/kitty";

    in pkgs.writeText "qtile-conf" ''
import os
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
# Handy variables!
mod = "mod4"
# Long application names suck!
# https://stackoverflow.com/questions/71346049/qtile-make-parse-function-for-long-texts-like-browsers
def longNameParse(text): 
    for string in ["Chromium", "Firefox", "Discord", "Cantata"]: #Add any other apps that have long names here
        if string in text:
            text = string
        else:
            text = text
    return text
## Applications
myTerminal = "kitty"
myBrowser = "firefox"
myEmail = "thunderbird"
myMusic = "cantata"
myScratchMusic = "kitty ncmpcpp"
myChat = "discord"
myVideogames = [
    "steam"
    "lutris"
         ]
# myPKM = "flatpak run md.obsidian.Obsidian"
## Playback commands for keybinds
myPlaybackPlay = "mpc toggle"
myPlaybackNext = "mpc next"
myPlaybackPrev = "mpc prev"
## Tweaks
barSpacer = 5
myMargin = 8 # gaps
myBorderWidth = 2
myScratchX = 0.25
myScratchY = 0.20
myScratchWidth = 0.55
myScratchHeight = 0.65

myPrimaryColor = "#14ff00"
mySecondaryColor = "#19b300"
# defaultLayoutSet = {'1':'monadtall', '2':'monadtall', '3':'monadtall', '4':'monadtall', '5':'max', '6':'monadtall', '7':'monadtall', '8':'monadtall', '9':'monadtall'}
# Keybinds:
keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "l", lazy.layout.grow_main(), desc="Grow main window"),
    Key([mod, "control"], "h", lazy.layout.shrink_main(), desc="Shrink main window"),
    Key([mod], "t", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle Maximimize and minimize
    Key([mod], "m", lazy.window.toggle_maximize(), desc="Toggle Maximize"),
    Key([mod], "n", lazy.window.toggle_minimize(), desc="Toggle Minimize"),
    #Key([mod], "shift", "m", lazy.window.toggle_fullscreen(), desc="Toggle Fullscreen"), 
    # Media keys
    Key([], "XF86AudioPlay", lazy.spawn(myPlaybackPlay), desc="Play/Pause in player"),
    Key([], "XF86AudioNext", lazy.spawn(myPlaybackNext), desc="Next track in player"),
    Key([], "XF86AudioPrev", lazy.spawn(myPlaybackPrev), desc="Prev track in player"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    # Floating windows
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "Return", lazy.spawn(myTerminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawn("${rofi} -show drun"), desc="Spawn an application launcher"),
    Key([mod], "t", lazy.spawn("${rofi} -show window"), desc="Spawn a window switcher"),
    # Group keybinds
    Key([mod], "1", lazy.group["1"].toscreen()),
    Key([mod], "2", lazy.group["2"].toscreen()),
    Key([mod], "3", lazy.group["3"].toscreen()),
    Key([mod], "4", lazy.group["4"].toscreen()),
    Key([mod], "5", lazy.group["5"].toscreen()),
    Key([mod], "6", lazy.group["6"].toscreen()),
    Key([mod], "7", lazy.group["7"].toscreen()),
    Key([mod], "8", lazy.group["8"].toscreen()),
    Key([mod], "9", lazy.group["9"].toscreen()),
    # Group keybinds - Moving active window
    Key([mod, "shift"], "1", lazy.window.togroup("1", switch_group=False)),
    Key([mod, "shift"], "2", lazy.window.togroup("2", switch_group=False)),
    Key([mod, "shift"], "3", lazy.window.togroup("3", switch_group=False)),
    Key([mod, "shift"], "4", lazy.window.togroup("4", switch_group=False)),
    Key([mod, "shift"], "5", lazy.window.togroup("5", switch_group=False)),
    Key([mod, "shift"], "6", lazy.window.togroup("6", switch_group=False)),
    Key([mod, "shift"], "7", lazy.window.togroup("7", switch_group=False)),
    Key([mod, "shift"], "8", lazy.window.togroup("8", switch_group=False)),
    Key([mod, "shift"], "9", lazy.window.togroup("9", switch_group=False)),
    Key([mod], "d", lazy.group['scratchpad'].dropdown_toggle('music')),
    Key([mod], "a", lazy.group['scratchpad'].dropdown_toggle("notes")),
    Key([mod], "s", lazy.group['scratchpad'].dropdown_toggle("social"))
                   ]
# Groups, scratchpads, and keybinds.
groups = [
    # Groups
    Group("1", layout="monadtall"),
    Group("2", layout="monadtall"),
    Group("3", layout="monadtall", spawn=myMusic),
    Group("4", layout="monadtall"),
    Group("5", layout="monadtall", spawn=myEmail),
    Group("6"),
    Group("7"),
    Group("8"),
    Group("9"),
    # Scratchpads
    ScratchPad("scratchpad", [
    #   DropDown("name", myApp, x=myScratchX, y=myScratchY, width=myScratchWidth, height=myScratchHeight, on_focus_lost_hide=True),
        DropDown("term", myTerminal, x=myScratchX, y=myScratchY, width=myScratchWidth, height=myScratchHeight, on_focus_lost_hide=True), # Terminal
        DropDown("music", myScratchMusic, x=myScratchX, y=myScratchY, width=myScratchWidth, height=myScratchHeight, on_focus_lost_hide=True), # Music
        DropDown("social", "vesktop", x=myScratchX, y=myScratchY, width=myScratchWidth, height=myScratchHeight, on_focus_lost_hide=True),
        DropDown("notes", "obsidian", x=myScratchX, y=myScratchY, width=myScratchWidth, height=myScratchHeight, on_focus_lost_hide=True),
    ])
       ]
layouts = [
    # layout.Columns(border_width=1),
    layout.MonadTall(margin=myMargin, border_width=myBorderWidth, border_focus=myPrimaryColor),
    # layout.Stack(num_stacks=2, margin=myMargin, border_width=myBorderWidth, border_focus=myPrimaryColor),
    layout.Max(),
    # layout.MonadThreeCol(margin=myMargin, border_width=myBorderWidth, border_focus=myPrimaryColor),
    # layout.Spiral(),
    # layout.TreeTab(border_width=myBorderWidth, active_bg=mySecondaryColor, fontsize=12, font="terminus", vspace=0),
    # layout.MonadWide(),
    # layout.Bsp(margin=myMargin, border_width_=myBorderWidth, border_focus=myPrimaryColor),
    # layout.Matrix(margin=myMargin, border_width=myBorderWidth, border_focus=myPrimaryColor),
    # layout.RatioTile(),
    # layout.Tile(margin=myMargin, border_width=myBorderWidth, border_focus=myPrimaryColor),
    # layout.VerticalTile(margin=myMargin, border_width=myBorderWidth, border_focus=myPrimaryColor),
    # layout.Zoomy(),
         ]
widget_defaults = dict(
    font="terminus",
    fontsize=12,
    padding=0,
          )
extension_defaults = widget_defaults.copy()
screens = [
    Screen(
        top=bar.Bar(        
                widget.Sep(padding=barSpacer, foreground=mySecondaryColor),
                widget.TaskList(
                    padding=2,
                    highlight_method='line',
                    border=myPrimaryColor,
                    title_width_method='uniform',
                    parse_text=longNameParse
                ),
                widget.Sep(padding=barSpacer, foreground=mySecondaryColor),
                widget.Mpd2(
                    idle_format='{play_status}',
                    status_format='{play_status}'
                ),
                widget.Spacer(length=2),
                widget.Mpd2(
                    idle_format="",
                    width=180,
                    status_format='{artist} - {title}',
                    scroll=True,
                    scroll_delay=2,
                    scroll_interval=0.1,
                    scroll_repeat=True
                ),
               widget.Sep(padding=barSpacer, foreground=mySecondaryColor),
                widget.Systray(
                    padding=0,
                    icon_size=16
                ),
                widget.Sep(padding=barSpacer, foreground=mySecondaryColor),
                widget.OpenWeather(location='Pittsburgh',
                                    metric=False,
                                    format='{weather}, {temp}F'
                                   ),
                widget.Sep(padding=barSpacer, foreground=mySecondaryColor),
                widget.Clock(format="%a, %m-%d %I:%M %p",
                              mouse_callbacks={
                                'Button1': lazy.spawn('dunstctl history-pop')}
                             ),
                           ),
            # 24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
    #         # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
    #     ),
    # ),
                           ]
# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
                ]
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gtk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="OneClick™ Installer"), # Beat Saber mod manager
        # Match(title="SteamVR Status"), #steamvr status window
    ]
              )
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = False
# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True
# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None
# Some java related thing, don't change this.
wmname = "LG3D"
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('qtile-autostart') # from builder
    subprocess.Popen([home])
    '';

  };  

}
