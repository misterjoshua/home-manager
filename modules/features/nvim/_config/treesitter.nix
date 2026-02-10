{ config, ... }:
{
  plugins.treesitter = {
    enable = true;

    highlight = {
      enable = true;
      additional_vim_regex_highlighting = false;
    };

    indent.enable = true;

    grammarPackages = config.plugins.treesitter.package.allGrammars;
  };
}
