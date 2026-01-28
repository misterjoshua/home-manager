{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.desktop
      self.modules.nixos.hyper-v-hardware
      self.modules.nixos.josh
      (_: {
        networking.hostName = "nixos";
        home-manager.users.josh = {
          imports = [
            self.modules.homeManager.guiProfile
            self.modules.homeManager.gamesProfile
          ];
        };
      })
    ];
  };
}
