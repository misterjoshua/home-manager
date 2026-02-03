{
  inputs,
  config,
  self,
  withSystem,
  lib,
  ...
}:
let
  featureOptionsType = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to enable the feature.";
      };
    };
  };

  homeConfigurationType = lib.types.submodule {
    options = {
      system = lib.mkOption {
        description = "The system to use for the home configuration.";
        type = lib.types.str;
      };
      features = lib.mkOption {
        type = lib.types.attrsOf featureOptionsType;
        description = "The features to enable for the home configuration.";
        default = { };
      };
    };
  };

  nixosConfigurationType = lib.types.submodule {
    options = {
      system = lib.mkOption {
        description = "The system to use for the NixOS configuration.";
        type = lib.types.str;
      };
      hostname = lib.mkOption {
        description = "The hostname to use for the NixOS configuration.";
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      hardware = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        description = "The hardware to use for the NixOS configuration. If not provided, we will try to load: hosts/_hardware/\${hostname}.nix";
        default = null;
      };
      features = lib.mkOption {
        type = lib.types.attrsOf featureOptionsType;
        description = "The features to enable for the NixOS configuration";
        default = { };
      };
    };
  };

  getHomeManagerFeature =
    name:
    if builtins.hasAttr name self.modules.homeManager then
      self.modules.homeManager.${name}
    else
      throw "You've attempted to enable non-existent feature named `${name}`. To use this feature, you should define it as `flake.modules.homeManager.${name}` and ensure your module is staged or committed.";

  getNixosFeature =
    name:
    if builtins.hasAttr name self.modules.nixos then
      self.modules.nixos.${name}
    else
      throw "You've attempted to enable non-existent feature named `${name}`. To use this feature, you should define it as `flake.modules.nixos.${name}` and ensure your module is staged or committed.";

  filterModuleExists = modules: lib.filterAttrs (name: _: builtins.hasAttr name modules);

  mkFeaturesWith =
    getFeature: features:
    let
      enabledFeatures = lib.filterAttrs (_: v: v.enable or false) features;
      featureModules = lib.mapAttrs (key: _: (getFeature key)) enabledFeatures;
    in
    lib.attrValues featureModules;

  mkHomeConfiguration =
    configurationName: homeConfiguration:
    withSystem homeConfiguration.system (
      { pkgs, ... }:
      let
        defaultFeatures = filterModuleExists self.modules.homeManager {
          default.enable = true;
          ${homeConfiguration.system}.enable = true;
        };
        features = defaultFeatures // homeConfiguration.features;
      in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = (mkFeaturesWith getHomeManagerFeature features);
      }
    );

  mkNixosConfiguration =
    configurationName: nixosConfiguration:
    withSystem nixosConfiguration.system (
      { system, ... }:
      let
        defaultFeatures = filterModuleExists self.modules.nixos {
          default.enable = true;
          ${system}.enable = true;
          ${nixosConfiguration.hostname}.enable = true;
        };
        hostName =
          if nixosConfiguration.hostname != null then nixosConfiguration.hostname else configurationName;
        features = defaultFeatures // nixosConfiguration.features;
        fallbackHardware = "./hosts/_hardware/${hostName}.nix";
        hardware =
          if nixosConfiguration.hardware != null then
            # Attempt to use the provided hardware module.
            nixosConfiguration.hardware
          else if builtins.pathExists ./${fallbackHardware} then
            # No hardware provided, so use the fallback hardware module.
            ./${fallbackHardware}
          else
            # No hardware provided and fallback hardware module does not exist, so this is an error.
            throw
              "No hardware provided for ${nixosConfiguration.hostname} and ${fallbackHardware} does not exist. Please supply the hardware option or place a hardware file at ${fallbackHardware} and ensure it is staged or committed.";
      in
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          (_: {
            networking.hostName = hostName;
          })
          hardware
        ]
        ++ (mkFeaturesWith getNixosFeature features);
      }
    );
in
{
  options = {
    dendritic = {
      homeConfigurations = lib.mkOption {
        description = "A dendritic design-aware module for creating Home Manager configurations.";
        type = lib.types.attrsOf homeConfigurationType;
        default = { };
      };

      nixosConfigurations = lib.mkOption {
        description = "A dendritic design-aware module for creating NixOS configurations.";
        type = lib.types.attrsOf nixosConfigurationType;
        default = { };
      };
    };
  };

  config = {
    flake.homeConfigurations = lib.mapAttrs mkHomeConfiguration config.dendritic.homeConfigurations;
    flake.nixosConfigurations = lib.mapAttrs mkNixosConfiguration config.dendritic.nixosConfigurations;
  };
}
