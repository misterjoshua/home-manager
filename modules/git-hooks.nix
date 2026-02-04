{ inputs, config, ... }:
{
  perSystem = { system, ... }: {
     pre-commit.settings.hooks.nixfmt.enable = true;


  };
}
