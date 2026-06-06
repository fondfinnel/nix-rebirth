{ self, inputs, config, ... }: let
  system = config.nixpkgs.hostPlatform;
in {

  flake.nixosModules.users = { pkgs, ... }: {
    
    users.users.n0ll = {
      isNormalUser = true;
      description = "Nathaniel Fagan";
      extraGroups = [ "uinput" "networkmanager" "wheel" "cdrom" "libvirtd" "kvm" "dialout" "tty" ];
      initialPassword = "123";
      shell = pkgs.fish;
      home = "/home/n0ll";
      # TODO hashedPassword
    };

    programs.fish.enable = true;

    # only necessary for importing home-manager as nixos-module
    environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];

    # likely removing once things are finalized, for testing purposes
    home-manager.users.n0ll = { ... }: {
      imports = [
        self.homeModules.n0ll-conf
      ];

    };

  };

  flake.homeConfigurations.n0ll = inputs.home-manager.lib.homeManagerConfiguration {
    # use architecture from system
    pkgs = import inputs.nixpkgs { system = system; };

    modules = with self.homeModules; [
      n0ll-conf
    ];
  };

  flake.homeModules.n0ll-conf = { pkgs, osConfig, config, ... }: {

    imports = with self.homeModules; [
      hyprland
      kitty
      common-utils
      gaming
      creative
      development
      keepassxc
      mpd
    ];

    home.sessionVariables = {
      EDITOR = "${pkgs.emacs}/bin/emacsclient -c -a ${pkgs.emacs}/bin/emacs -nw";
    };

    home.shellAliases = {
      nshp = "nix-shell -p"; # installing programs temporarily
      ":q" = "exit";
      blkid = "sudo blkid";
    };

    programs.ledger.enable = true;

    services.mpdscribble.endpoints."last.fm" = {
      username = "natervader13";
      # TODO SOPS
      # passwordFile = osConfig.sops.secrets."keys/n0ll/lastfm".path; 
    };

  };

}
