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

  # Add cool-factor to a few nixos feature-sets.
  flake.modules.nixos.workstation =
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
