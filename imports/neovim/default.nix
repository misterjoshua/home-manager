{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    neovim
  ];

  home.shellAliases = {
    vim = "nvim";
    vi = "nvim";
    vimdiff = "nvim -d";
  };

  # Default editor
  home.sessionVariables.EDITOR = "nvim";
  
  home.file.".vimrc".source = ./vimrc;
}
