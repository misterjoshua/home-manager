{ ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.email = "joshkellendonk@gmail.com";
      user.name = "Josh Kellendonk";
      extraConfig = {
        pull.rebase = true;
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
      };
    };
  };

  programs.gh.enable = true; # Manage github cli.
}
