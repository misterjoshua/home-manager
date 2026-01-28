{ inputs, ... }:
{
  flake.modules.homeManager.homeManagerConfig =
    { pkgs, ... }:
    {
      nix.package = pkgs.nix;
      programs.home-manager.enable = true;
    };

  flake.modules.nixos.homeManagerConfig =
    { ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = false;
        backupFileExtension = "backup";
      };
    };
}
