{
  self,
  ...
}:
{
  flake = {
    modules.homeManager.distoEnv =
      { pkgs, ... }:
      {
        nix.package = pkgs.nix;
        programs.home-manager.enable = true;
      };

    modules.homeManager.joshHome =
      { ... }:
      {
        imports = [
          self.modules.homeManager.nixConfig
          self.modules.homeManager.commonProfile
        ];

        home = {
          username = "josh";
          homeDirectory = "/home/josh";
          stateVersion = "24.11";
        };
      };
  };
}
