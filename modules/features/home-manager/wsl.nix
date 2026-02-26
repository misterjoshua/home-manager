{
  flake.modules.homeManager.wsl =
    { ... }:
    {
      targets.genericLinux.enable = true;
      targets.genericLinux.gpu.enable = false;
      home.shellAliases = {
        explorer = "/mnt/c/Windows/explorer.exe";
      };
    };
}
