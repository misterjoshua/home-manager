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
      hardware = lib.mkOption {
        type = lib.types.either lib.types.path lib.types.deferredModule;
        description = "The hardware to use for the NixOS configuration.";
      };
      hostname = lib.mkOption {
        description = "The hostname to use for the NixOS configuration.";
        type = lib.types.nullOr lib.types.str;
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
      throw "You've attempted to enable non-existent feature named `${name}`. To use this feature, you should define it as `flake.modules.homeManager.${name}`";

  getNixosFeature =
    name:
    if builtins.hasAttr name self.modules.nixos then
      self.modules.nixos.${name}
    else
      throw "You've attempted to enable non-existent feature named `${name}`. To use this feature, you should define it as `flake.modules.nixos.${name}`";

  mkFeaturesWith =
    getFeature: features:
    let
      enabledFeatures = lib.filterAttrs (_: v: v.enable or false) features;
      featureModules = lib.mapAttrs (key: _: (getFeature key)) enabledFeatures;
    in
    lib.attrValues featureModules;

  mkHomeConfiguration =
    name: home:
    withSystem home.system (
      { pkgs, ... }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = (mkFeaturesWith getHomeManagerFeature home.features);
      }
    );

  mkNixosConfiguration =
    name: nixosConfiguration:
    withSystem nixosConfiguration.system (
      { system, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          (
            _:
            lib.mkIf (nixosConfiguration.hostname != null) {
              networking.hostName = nixosConfiguration.hostname;
            }
          )
          nixosConfiguration.hardware
        ]
        ++ (mkFeaturesWith getNixosFeature nixosConfiguration.features);
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
