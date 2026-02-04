{
  ...
}:
{
  dendritic.nixosConfigurations.swagbox = {
    system = "x86_64-linux";
    features.htpc.enable = true;
    features.josh.enable = true;
  };
}
