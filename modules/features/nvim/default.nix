{ inputs, self, ... }:
{
  flake.modules.homeManager.nvim =
    { ... }:
    {
      imports = [ inputs.nixvim.homeModules.nixvim ];
      programs.nixvim.enable = true;
      programs.nixvim.imports = [
        (inputs.import-tree ./_config)
      ];

      home.shellAliases = {
        vim = "nvim";
        vi = "nvim";
        vimdiff = "nvim -d";
      };

      # Default editor
      home.sessionVariables.EDITOR = "nvim";
    };

  flake.modules.homeManager.shell = self.modules.homeManager.nvim;
}
