{
  flake.modules.homeManager.wsl =
    { ... }:
    {
      home.shellAliases = {
        explorer = "/mnt/c/Windows/explorer.exe";
      };
    };
}
