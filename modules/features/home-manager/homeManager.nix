{ inputs, ... }:
{
  flake.modules.homeManager.homeManager =
    { pkgs, ... }:
    {
      nix.package = pkgs.nix;
      programs.home-manager.enable = true;
    };

  flake.modules.nixos.homeManager =
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
