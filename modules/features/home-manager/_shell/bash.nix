{ ... }:
{
  # Manage bash's config.
  programs.bash.enable = true;
  programs.bash.shellOptions = [
    "histappend"
    "extglob"
    "globstar"
    "checkjobs"
    "no_empty_cmd_completion"
  ];
}
