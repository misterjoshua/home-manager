{
  inputs,
  self,
  ...
}:
let
  nixpkgs = inputs.nixpkgs;
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  home-manager = inputs.home-manager;

  utils = (import ../modules/home-manager-utils).override {
    inherit pkgs home-manager;
    extraModules = [
      inputs.self.modules.homeManager.nixConfig
      inputs.self.modules.homeManager.commonProfile
    ];
  };
  nixos = import ../modules/nixos;
in
{
  flake = {
    homeConfigurations.josh = utils.standaloneHome {
      username = "josh";
    };

    homeConfigurations.josh-wsl = utils.standaloneHome {
      username = "josh";
      modules = [
        inputs.self.modules.homeManager.wslProfile
      ];
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.self.modules.nixos.nixConfig
        (nixos.configuration {
          hostName = "nixos";
          hardware = nixos.hardware.hyper-v;
        })
        (utils.nixosUsers {
          users.josh = {
            modules = [
              inputs.self.modules.homeManager.guiProfile
              inputs.self.modules.homeManager.gamesProfile
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
        inputs.self.modules.nixos.nixConfig
        (nixos.configuration {
          hostName = "swagbox";
          hardware = nixos.hardware.swagbox;
        })
        (utils.nixosUsers {
          users.josh = {
            modules = [
              inputs.self.modules.homeManager.guiProfile
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
