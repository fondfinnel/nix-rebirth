{
  description = "Rewrite of my NixOS repo, using flake-parts as a base.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:denful/import-tree";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master"; 
      inputs.nixpkgs.follows = "nixpkgs"; 
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservatoin";
    
    disko.url = "github:/nix-community/disko";
    
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    +
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree [
        ./modules
      ]);
}
