{ self, inputs, config, ... }: let
  system = config.nixpkgs.hostPlatform;
in {

  flake.nixosModules.users-n0ll = { pkgs, ... }: {
    
    users.users.n0ll = {
      isNormalUser = true;
      description = "Nathaniel Fagan";
      extraGroups = [ "uinput" "networkmanager" "wheel" "cdrom" "libvirtd" "kvm" "dialout" "tty" ];
      initialPassword = "123";
      shell = pkgs.fish;
      home = "/home/n0ll";
    };

    programs.fish.enable = true;

    # only necessary for importing home-manager as nixos-module
    environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];

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

    imports = [
      self.homeModules.hyprland
      self.homeModules.kitty
    ];

    home.sessionVariables = {
      EDITOR = "${pkgs.emacs}/bin/emacsclient -c -a ${pkgs.emacs}/bin/emacs -nw";
      SHELL = "${osConfig.users.users."${config.home.username}".shell}";
    };

    programs.kitty.enable = true;
  };
}
