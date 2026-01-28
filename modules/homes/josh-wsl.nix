{
  inputs,
  self,
  withSystem,
  ...
}:
{
  flake.homeConfigurations.josh-wsl = withSystem "x86_64-linux" (
    { pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        self.modules.homeManager.homeManagerConfig
        self.modules.homeManager.josh
        self.modules.homeManager.wslProfile
      ];
    }
  );
}
