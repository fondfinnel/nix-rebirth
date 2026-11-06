{
  description = "Rewrite of my NixOS repo, using flake-parts as a base.";

  # declare external dependencies
  inputs = {
    # pulls compressed archive of nixpkgs rather than the raw repo
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    # nixpkgs.url = "github:NixOS/nixpkgs/067f2d5a1099e06f9afb944e96e32724d3c5452b";

    # for dendritic style modules
    flake-parts.url = "github:hercules-ci/flake-parts";

    # import all the things
    import-tree.url = "github:denful/import-tree";

    # better user management
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # helps with some stuff.. I think
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # declare firefox addons to install by default
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # better container management
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    # store root filesystem onto RAM
    # declare parts of system that actually need to be kept after reboot
    preservation.url = "github:nix-community/preservation";

    # declare disk partitioning
    # very helpful for installs
    disko.url = "github:/nix-community/disko";

    # you're not getting my secrets newman
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # additional modules for specific hardware
    # primarily for laptops
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # declared colors and injects into many apps
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ironbar opts are not in home-manager / nixos
    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # manage doom-emacs install through nixpkgs itself
    # better declaration / reproducability, worse rebuilds
    # benefits for tradeoff
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
    };
  };

  # import all modules under ./modules
  # have each module inherit flake inputs
  # import each module as a flake itself
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree [
        ./modules
      ]
    );

  # add additional binary caches
  # for some reason, does not really work by default
  # always need to pass "--accept-flake-config" atm
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://doom-emacs-unstraightened.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "doom-emacs-unstraightened.cachix.org-1:O5oOlRPnmQEvVaFyuMTmthCEooHbrg54WgSLR07tmg4="
    ];
  };

}
