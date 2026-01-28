{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      # Define the pkgs argument for all systems.
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
}
