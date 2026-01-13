{
  pkgs,
  lib,
  config,
  ...
}:
{
  home = {
    username = "josh";
    homeDirectory = "/home/josh";
    stateVersion = "24.11"; # Don't change this.
  };
}
