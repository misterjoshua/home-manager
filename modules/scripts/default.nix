{ ... }:

{
  programs.bash.shellAliases = {
    hmu = "home-manager-update";
  };

  home.file = {
    ".local/bin/home-manager-update".source = ./home-manager-update;
  };
}
