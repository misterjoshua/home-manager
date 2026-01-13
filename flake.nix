{
  description = "Home Manager Flake";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:

    let
      mkHome = pkgs: modules: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = modules;
        inherit;
      };
    in
    {
      shells.x86_64-linux = {
        inherit (nixpkgs.legacyPackages.x86_64-linux) bash;
      };

      homeConfigurations.josh = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./profiles/josh.nix
          ./profiles/home.nix
          ./profiles/wsl.nix
        ];
      };
    };
}
