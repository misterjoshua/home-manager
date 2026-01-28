{
  self,
  ...
}:
let
  stateVersion = "24.11";
  homeImports = [
    self.modules.homeManager.nixConfig
    self.modules.homeManager.commonProfile
  ];
in
{
  flake = {
    modules.homeManager.josh =
      { ... }:
      {
        imports = homeImports;

        home = {
          username = "josh";
          homeDirectory = "/home/josh";
          inherit stateVersion;
        };
      };

    modules.nixos.josh =
      {
        ...
      }:
      {
        users.users.josh = {
          isNormalUser = true;
          description = "Josh";
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
        };

        home-manager.users.josh = {
          imports = homeImports;
          home.stateVersion = stateVersion;
        };
      };
  };
}
