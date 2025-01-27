{ config, pkgs, lib, ... }:

{
  programs.bash.shellAliases = {
    vim = "nvim";
  };
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.file.".vimrc".source = neovim/vimrc;
}
