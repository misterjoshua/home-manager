{
  ...
}:
{
  dendritic.nixosConfigurations.nixos = {
    system = "x86_64-linux";
    hardware = ./_hardware/hyper-v.nix;
    hostname = "nixos";
    features.desktop.enable = true;
    features.josh.enable = true;
  };
}
