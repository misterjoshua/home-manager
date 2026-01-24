{
  flake.modules.homeManager.gamesProfile =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        steam
      ];
    };
}
