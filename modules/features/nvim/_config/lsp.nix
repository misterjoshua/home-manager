{ ... }:
{
  plugins.lsp = {
    enable = true;
    # inlayHints = true;

    servers = {
      bashls.enable = true;
      nixd.enable = true;
      ts_ls.enable = true;
      jsonls.enable = true;
      eslint.enable = true;
      prettier.enable = true;
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
}
