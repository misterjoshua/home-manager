{
  flake.modules.homeManager.wsl =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        chromium
      ];

      targets.genericLinux.enable = true;
      targets.genericLinux.gpu.enable = false;
      home.shellAliases = {
        explorer = "/mnt/c/Windows/explorer.exe";
      };
    };
}
