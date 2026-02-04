{
  config,
  ...
}:
{
  flake.modules.nixos.cool-factor =
    { pkgs, ... }:
    {
      boot.plymouth = {
        enable = true;
        theme = "deus_ex";
        themePackages = [
          pkgs.adi1090x-plymouth-themes
        ];
      };
    };

  flake.modules.homeManager.cool-factor =
    { pkgs, ... }:
    {
      # Not sure yet what to add here.
    };

  # Add cool-factor to a few nixos feature-sets.
  flake.modules.nixos.desktop =
    { ... }:
    {
      imports = [
        config.flake.modules.nixos.cool-factor
      ];
    };

  flake.modules.nixos.htpc =
    { ... }:
    {
      imports = [
        config.flake.modules.nixos.cool-factor
      ];
    };
}
