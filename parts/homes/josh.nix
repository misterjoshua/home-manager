{
  inputs,
  self,
  withSystem,
  ...
}:
{
  flake.homeConfigurations.josh = withSystem "x86_64-linux" (
    { pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        self.modules.homeManager.distoEnv
        self.modules.homeManager.joshHome
      ];
    }
  );
}
