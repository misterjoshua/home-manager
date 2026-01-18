{
  self,
  nixpkgs,
  home-manager,
  home-manager-utils,
  flake-parts,
  nixConfig,
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

  nixosConfigurations.swagbox = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      nixSettings
      (nixos.configuration {
        hostName = "swagbox";
        hardware = nixos.hardware.swagbox;
      })
      (utils.nixosUsers {
        users.josh = {
          modules = [
            ./profiles/gui.nix
          ];
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
        };
      })
    ];
  };
}
