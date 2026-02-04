{ ... }:
{
  perSystem =
    { config, pkgs, ... }:
    {
      pre-commit.settings.hooks.nixfmt.enable = true;
      formatter = pkgs.nixfmt-tree;

      devShells.default = pkgs.mkShell {
        packages =
          with pkgs;
          [
            nixfmt
            nixd
            nixos-rebuild
            age
          ]
          ++ config.pre-commit.settings.enabledPackages;
        shellHook = ''
          ${config.pre-commit.shellHook}
          echo "Welcome to the Dev Shell"
        '';
      };
    };
}
