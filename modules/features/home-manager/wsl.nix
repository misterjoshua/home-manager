{
  flake.modules.homeManager.wsl =
    { ... }:
    {
      targets.genericLinux.enable = true;
      home.shellAliases = {
        explorer = "/mnt/c/Windows/explorer.exe";
      };
    };
}
