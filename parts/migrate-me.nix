{
  inputs,
  self,
  pkgs,
  ...
}:
let
  nixpkgs = inputs.nixpkgs;
  home-manager = inputs.home-manager;

  utils = (import ../modules/home-manager-utils).override {
    inherit pkgs home-manager;
    extraModules = [
      self.modules.homeManager.nixConfig
      self.modules.homeManager.commonProfile
    ];
  };
  nixos = import ../modules/nixos;
in
{
  flake = {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.modules.nixos.nixConfig
        (nixos.configuration {
          hostName = "nixos";
          hardware = nixos.hardware.hyper-v;
        })
        (utils.nixosUsers {
          users.josh = {
            modules = [
              self.modules.homeManager.guiProfile
              self.modules.homeManager.gamesProfile
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
      system = "x86_64-linux";
      modules = [
        self.modules.nixos.nixConfig
        (nixos.configuration {
          hostName = "swagbox";
          hardware = nixos.hardware.swagbox;
        })
        (utils.nixosUsers {
          users.josh = {
            modules = [
              self.modules.homeManager.guiProfile
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
