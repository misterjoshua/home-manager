{ lib, config, ... }:
{
  plugins.lsp = {
    enable = true;
    inlayHints = true;

    servers = {
      bashls.enable = true;
      nixd.enable = true;
      jsonls.enable = true;
      eslint.enable = true;
      prettier.enable = true;
      ts_ls.enable = true;
    };

    postConfig = ''
      vim.diagnostic.config({
        underline = true;
        virtual_text = true;
        virtual_lines = true;
        signs = true;
        float = true;
      })
    '';
  };

  plugins.lsp-format = lib.mkIf (config.plugins.lsp.enable) {
    enable = true;
  };
}
