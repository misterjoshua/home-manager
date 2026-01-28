{ self, ... }:
{

  dendritic = {
    homeConfigurations.dendritic-test = {
      system = "x86_64-linux";
      features.josh.enabled = true;
      features.wsl.enabled = true;
    };

    nixosConfigurations.dendritic-test = {
      system = "x86_64-linux";
      hostname = "dendritic-test";
      hardware = self.modules.nixos.hyper-v-hardware;
      features.desktop.enabled = true;
      features.josh.enabled = true;
      # features.nonexistent.enabled = true;
    };
  };

}
