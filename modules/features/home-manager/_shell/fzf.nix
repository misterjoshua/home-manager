{ ... }:
{
  # FZF for fuzzy search of files and autocomplete.
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--height 75%"
      "--min-height 10"
      "--border"
    ];
    fileWidgetOptions = [
      "--preview 'bat --color=always {}'"
    ];
    tmux.enableShellIntegration = true;
  };
}
