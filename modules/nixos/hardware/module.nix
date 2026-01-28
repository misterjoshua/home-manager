{ ... }:
{
  flake.modules.nixos.hyper-v-hardware = import ./_hyper-v.nix;
  flake.modules.nixos.swagbox-hardware = import ./_swagbox.nix;
}
