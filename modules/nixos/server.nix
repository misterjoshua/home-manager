{ self, ... }:
{
  flake.modules.nixos.server =
    { ... }:
    {
      imports = [
        self.modules.nixos.base
      ];
    };
}
