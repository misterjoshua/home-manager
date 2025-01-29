{ ... }:

{
  programs.bash.shellAliases = {
    hmu = "home-manager-update";
  };
  
  home.file = {
    ".local/bin/home-manager-update".source = scripts/home-manager-update;
  };
}