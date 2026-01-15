rec {
  description = "KlonkadonkOS";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-utils = {
      url = ./home-manager-utils;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      home-manager-utils,
      self,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkSystemUsers = import ./nixos/user.nix { inherit home-manager; };
    in
    {
      devShells.${system}.default = import ./shell.nix { inherit pkgs; };

      homeConfigurations.josh = home-manager-utils.standaloneHome {
        username = "josh";
        modules = [
          ./profiles/common.nix
        ];
      };

      homeConfigurations.josh-wsl = home-manager-utils.standaloneHome {
        username = "josh";
        modules = [
          ./profiles/common.nix
          ./profiles/wsl.nix
        ];
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/configuration.nix
          (home-manager-utils.nixosUsers {
            users.josh = {
              modules = [
                ./profiles/common.nix
                ./profiles/gui.nix
                ./profiles/games.nix
              ];
              extraGroups = [
                "networkmanager"
                "wheel"
              ];
            };
          })
        ];
      };
    };
}
