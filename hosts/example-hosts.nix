{
  ...
}:
{
  # Dendritic.nixosConfigurations.{configurationName} produces nixosConfiguration outputs.
  # - Each configuration has a system, optionally a hostname, optionally a hardware module, and optional additional features.
  # - The hostname defaults to the configuration name if not provided.
  # - The hardware defaults to hosts/_hardware/${hostname}.nix if not provided.
  # - Each configuration can have additional features, which map to flake.modules.nixos.${featureName}.
  #
  # By convention, each nixosConfiguration automatically enables the following features:
  # - features.default.enable = true; Defaults for all nixos configurations.
  # - features.${configurationName}.enable = true; The nixos configuration for the given configuration name.
  # - features.${system}.enable = true; The nixos configuration for the given system. Specialization per system. i.e., x86_64-linux, aarch64-linux, etc.
  # - features.${hostname}.enable = true; The nixos configuration for the given hostname.
  #
  # Additional features can be added by adding to the features attribute:
  # - features.workstation.enable = true; Enables a graphical workstation environment.
  # - features.office-synergy-server.enable = true; Registers mouse/kb sharing in the office.
  # - features.office-synergy-client.enable = true; Registers for control by the officeSynergyServer.
  # - features.family-access.enable = true; Enables family access, allowing family to switch the machine to family mode.
  # - features.family-mode.enable = true; Enables family mode, which configures the machine for family use.

  dendritic.nixosConfigurations.nyx = {
    system = "x86_64-linux";

    # By convention, automatically enables the following features:
    # - features.default.enable = true; Defaults for all nixos configurations.
    # - features.x86_64-linux.enable = true;
    # - features.nyx.enable = true; The nixos configuration for the derived hostname and configuration name.

    features.workstation.enable = true;
    features.office-synergy-client.enable = true;
  };

  dendritic.nixosConfigurations.kermit = {
    system = "x86_64-linux";

    # By convention, automatically enables the following features:
    # - features.default.enable = true; Defaults for all nixos configurations.
    # - features.x86_64-linux.enable = true;
    # - features.kermit.enable = true; The nixos configuration for the derived hostname and configuration name.

    # Enables the media server features.
    features.media-server.enable = true;
    features.office-synergy-client.enable = true;
  };

  # Vac is a workstation that can be used by the family.
  dendritic.nixosConfigurations.vac = {
    system = "x86_64-linux";

    # By convention, automatically enables the following features:
    # - features.vac.enable = true; The nixos configuration for the derived hostname and configuration name.
    # - features.default.enable = true;
    # - features.x86_64-linux.enable = true;

    features.workstation.enable = true;
    features.office-synergy-server.enable = true;

    # Family can access this computer and switch it to family mode.
    features.family-access.enable = true;
  };

  # Vac-family-mode is what
  dendritic.nixosConfigurations.vac-family-mode = {
    system = "x86_64-linux";
    # Explicitly provide the hostname and hardware module.
    hostname = "vac";
    hardware = ./_hardware/vac.nix;

    # By convention, automatically enables the following features:
    # - features.default.enable = true;
    # - features.vac-family-mode.enable = true; The nixos configuration for the given configuration name.
    # - features.vac.enable = true; The nixos configuration for the given hostname
    # - features.x86_64-linux.enable = true;

    # Family can access this computer and switch to family mode (already active)
    features.family-access.enable = true;
    # Family mode aspect configures the machine for family use.
    features.family-mode.enable = true;
  };

}
