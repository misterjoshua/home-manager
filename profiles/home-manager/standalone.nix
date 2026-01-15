{
  username,
  homeDirectory ? "/home/${username}",
  stateVersion ? "24.11",
}:
{ pkgs, ... }:
{

  home = { inherit username homeDirectory stateVersion; };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.home-manager.enable = true;
}
