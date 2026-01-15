{ home-manager }:
{
  users ? { },
}:
{ ... }:
let
  mkSystemUser = (
    username: config: {
      isNormalUser = true;
      description = username;
      extraGroups = [ ] ++ config.groups;
    }
  );
  mkHomeManagerUser = (
    username: config: {
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
      };
      imports = [ ] ++ config.modules;
    }
  );
in
{
  users.users = builtins.mapAttrs mkSystemUser users;

  imports = [
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = false;
        backupFileExtension = "backup";
        users = builtins.mapAttrs mkHomeManagerUser users;
      };
    }
  ];
}
