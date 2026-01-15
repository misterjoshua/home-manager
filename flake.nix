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
  };

  outputs =
    {
      nixpkgs,
      home-manager,
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
      homeManagerProfile = import ./profiles/home-manager;
    in
    {
      devShells.${system}.default = import ./shell.nix { inherit pkgs; };

      homeConfigurations.josh = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (homeManagerProfile.standalone { username = "josh"; })
          ./profiles/common.nix
        ];
      };

      homeConfigurations.josh-wsl = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (homeManagerProfile.standalone { username = "josh"; })
          ./profiles/common.nix
          ./profiles/wsl.nix
        ];
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/configuration.nix
          (mkSystemUsers {
            users.josh = {
              groups = [
                "networkmanager"
                "wheel"
              ];
              modules = [
                (homeManagerProfile.nixos { })
                ./profiles/common.nix
                ./profiles/gui.nix
                ./profiles/games.nix
              ];
            };
          })
        ];
      };
    };
}
