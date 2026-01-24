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
  flake.modules.homeManager.nixConfig = _: { nix.settings = settings; };
  flake.modules.nixos.nixConfig = _: { nix.settings = settings; };
}
