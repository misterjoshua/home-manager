{ ... }:
{
  # Powerline prompt line
  programs.powerline-go.enable = true;
  programs.powerline-go.settings = {
    mode = "flat"; # flat so it works in more terminals
    modules = [
      "user" # Show the user.
      "host" # Show the host.
      "cwd" # Show the current working directory.
      "direnv" # Show the direnv context.
      "git" # Git info
      "venv"
      "kube" # Show the current kubernetes context.
      "newline"
      "root" # Show if you're root.
    ];
  };
}
