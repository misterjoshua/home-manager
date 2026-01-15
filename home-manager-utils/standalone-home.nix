{
  self,
  nixpkgs,
  home-manager,
}:
{
  username,
  modules ? [ ],
}:
let
  setupModule =
    { pkgs, ... }:
    {
      nix = {
        package = pkgs.nix;
        settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      programs.home-manager.enable = true;
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "24.11";
      };
    };
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [ setupModule ] ++ modules;
}
