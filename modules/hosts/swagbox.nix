{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.swagbox = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.desktop
      self.modules.nixos.swagbox-hardware
      self.modules.nixos.josh
      (_: { networking.hostName = "swagbox"; })
    ];
  };
}
