{ inputs, config, ... }:
{
  perSystem =
    { system, pkgs, ... }:
    {
      pre-commit.settings.hooks.nixfmt.enable = true;
      formatter = pkgs.nixfmt-tree;
    };
}
