{
  self,
  nixpkgs,
  home-manager,
}:
{
  users ? { },
}:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  mkSystemUser = (
    username: config: {
      isNormalUser = true;
      description = username;
      extraGroups = [ ] ++ config.extraGroups;
    }
  );

  mkHomeManagerUser = (
    username: config: {
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
      };
    }
  );
in
{
  # Ensure that the nixos users are created
  users.users = builtins.mapAttrs mkSystemUser users;

  imports = [
    # Now import home manager configs
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
