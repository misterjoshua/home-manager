{
  description = "KlonkadonkOS Home Manager Utilities";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      ...
    }:
    let
      lib = import ./lib.nix;
    in
    lib.override {
      inherit home-manager;
    };
}
