{
  flake.modules.homeManager.guiProfile =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vscode
        code-cursor
        _1password-gui
      ];
    };
}
