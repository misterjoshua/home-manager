{
  home-manager,
  users ? { },
  extraModules ? [ ],
  ...
}:
let
  mkSystemUser = (
    username: config: {
      isNormalUser = true;
      description = username;
      extraGroups = [ ] ++ config.extraGroups;
    }
  );

  mkHomeManagerUser = (
    username: config: {
      imports = [
        (import ./home.nix { inherit username; })
      ]
      ++ config.modules
      ++ extraModules;
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
