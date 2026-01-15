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
      nixpkgs,
      home-manager,
    }:
    {
      standaloneHome = import ./standalone-home.nix {
        inherit self nixpkgs home-manager;
      };

      nixosUser = import ./nixos-user.nix {
        inherit self nixpkgs home-manager;
      };
    };
}
