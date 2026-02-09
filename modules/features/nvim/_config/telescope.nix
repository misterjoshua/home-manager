{ pkgs, ... }:
{
  # Explicitly enable web-devicons dependency for telescope.
  plugins.web-devicons.enable = true;
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>ff" = {
        action = "git_files";
        options = {
          desc = "Telescipe Git Files";
        };
      };
      "<leader>fg" = {
        action = "live_grep";
        options = {
          desc = "Telescipe Live Grep";
        };
      };
      "<leader>fb" = {
        action = "buffers";
        options = {
          desc = "Telescipe Buffers";
        };
      };
      "<leader>fh" = {
        action = "help_tags";
        options = {
          desc = "Telescipe Help Tags";
        };
      };
    };
  };
}
