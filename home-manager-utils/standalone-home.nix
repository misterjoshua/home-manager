{
  self,
  home-manager,
  username,
  pkgs,
  modules ? [ ],
  extraModules ? [ ],
  ...
}:
let
  standaloneModule =
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
    };
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    (import ./home.nix { inherit username; })
    standaloneModule
  ]
  ++ modules
  ++ extraModules;
}
