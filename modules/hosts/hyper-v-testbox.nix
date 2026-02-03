{
  ...
}:
{
  dendritic.nixosConfigurations.hyper-v-testbox = {
    system = "x86_64-linux";
    hardware = ./_hardware/hyper-v.nix;
    features.desktop.enable = true;
  };
}
