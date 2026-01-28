{
  flake.modules.homeManager.wslProfile =
    { ... }:
    {
      home.shellAliases = {
        explorer = "/mnt/c/Windows/explorer.exe";
      };
    };
}
