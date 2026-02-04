{ ... }:
let
  settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
in
{
  flake.modules.homeManager.nix = _: { nix.settings = settings; };
  flake.modules.nixos.nix = _: { nix.settings = settings; };
}
