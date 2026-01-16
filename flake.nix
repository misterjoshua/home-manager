rec {
  description = "KlonkadonkOS";

  inputs = {
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
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      home-manager-utils,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      nixSettings = _: { nix.settings = nixConfig; };

      utils = home-manager-utils.override {
        inherit pkgs;
        extraModules = [
          nixSettings
          ./profiles/common.nix
        ];
      };
      nixos = import ./nixos;
    in
    {
      devShells.${system}.default = import ./shell.nix { inherit pkgs; };

      homeConfigurations.josh = utils.standaloneHome {
        username = "josh";
      };

      homeConfigurations.josh-wsl = utils.standaloneHome {
        username = "josh";
        modules = [
          ./profiles/wsl.nix
        ];
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixSettings
          (nixos.configuration {
            hostName = "nixos";
            hardware = nixos.hardware.hyper-v;
          })
          (utils.nixosUsers {
            users.josh = {
              modules = [
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
