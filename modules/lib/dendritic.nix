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
      enabled = lib.mkOption {
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
        type = lib.types.str;
      };
      hardware = lib.mkOption {
        type = lib.types.either lib.types.path lib.types.deferredModule;
        description = "The hardware to use for the NixOS configuration.";
      };
      features = lib.mkOption {
        type = lib.types.attrsOf featureOptionsType;
        description = "The features to enable for the NixOS configuration";
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

  mkHomeConfiguration = name: home: {
    ${name} = withSystem home.system (
      { pkgs, ... }:
      let
        features = lib.filterAttrs (_: v: v.enabled or false) home.features;
        featureModules = lib.attrValues (
          lib.mapAttrs (name: featureOptions: (getHomeManagerFeature name)) features
        );
      in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = featureModules;
      }
    );
  };

  mkNixosConfiguration =
    name: nixos:
    withSystem nixos.system (
      { ... }:
      let
        hostnameModule =
          if nixos.hostname != null then (_: { networking.hostName = nixos.hostname; }) else null;
        features = lib.filterAttrs (_: v: v.enabled or false) nixos.features;
        featureModules = lib.attrValues (
          lib.mapAttrs (name: featureOptions: (getNixosFeature name)) features
        );
      in
      inputs.nixpkgs.lib.nixosSystem {
        system = nixos.system;
        modules = [
          hostnameModule
          nixos.hardware
        ]
        ++ featureModules;
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
    flake.homeConfigurations = builtins.mapAttrs mkHomeConfiguration config.dendritic.homeConfigurations;
    flake.nixosConfigurations = builtins.mapAttrs mkNixosConfiguration config.dendritic.nixosConfigurations;
  };
}
