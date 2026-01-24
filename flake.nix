{
  description = "KlonkadonkOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {

    imports = [
      # https://github.com/mightyiam/dendritic?tab=readme-ov-file
      # https://github.com/Doc-Steve/dendritic-design-with-flake-parts/
      inputs.flake-parts.flakeModules.modules
      (inputs.import-tree ./parts)
    ];
  };
}
