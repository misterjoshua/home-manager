{
  ...
}:
{
  dendritic.nixosConfigurations.swagbox = {
    system = "x86_64-linux";
    hardware = ./_hardware/swagbox.nix;
    hostname = "swagbox";
    features.desktop.enable = true;
    features.josh.enable = true;
  };
}
