rec {
  description = "KlonkadonkOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        systems = [ "x86_64-linux" ];
        imports = [ ./shells.nix ];
        flake = import ./migrate-me.nix (inputs // { inherit nixConfig; });
      }
    );
}
