{ home-manager, pkgs }:
{
  common = profileArg: {
    imports = [
      ./common.nix
    ];
  };

  standalone = profileArg: {
    imports = [
      (import ./standalone.nix profileArg)
      ./common.nix
    ];
  };

  nixos = profileArg: _: {
    imports = [
      (import ./nixos.nix profileArg)
      ./common.nix
    ];
  };

  wsl = import ./wsl.nix;
  games = import ./games.nix;
}
