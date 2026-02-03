{ ... }:
{
  # This is a collector dendrite for "default" features registered by other modules.
  flake.modules.nixos.default = { ... }: { };
  flake.modules.homeManager.default = { ... }: { };
}
