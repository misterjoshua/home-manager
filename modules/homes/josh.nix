{
  ...
}:
{
  dendritic.homeConfigurations.josh = {
    system = "x86_64-linux";
    features.josh.enable = true;
  };

  dendritic.homeConfigurations.josh-wsl = {
    system = "x86_64-linux";
    features.josh.enable = true;
    features.wsl.enable = true;
  };
}
