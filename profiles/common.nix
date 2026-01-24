{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ../modules/home/granted.nix
    ../modules/home/kube.nix
    ../modules/home/neovim.nix
    ../modules/home/nvm.nix
    ../modules/home/ollama.nix
    ../modules/home/scripts
    ../modules/home/terminus.nix
    ../modules/home/tfenv.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    _1password-cli
    pipx
    apg
    # Shells
    powershell
    bash
    # Language Servers
    lua-language-server
    vim-language-server
    nixd
    # Git
    git
    git-lfs
    git-crypt
    gh
    # Cloud
    awscli2
    steampipe
    # CLI utils
    jq
    yq
    tree
    htop
    tmux
    graphviz
    unzip
    binwalk
    # Network
    curl
    mtr
    traceroute
    netcat
    nmap
    httpie
    wget
    ngrok
    dig
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    PATH = "$PATH:$HOME/.config/composer/vendor/bin:$HOME/.local/bin";
  };

  # Manage bash's config.
  programs.bash.enable = true;
  programs.bash.shellAliases = {
    l = "ls --color=auto";
    ll = "ls -l --color=auto";
    ls = "ls --color=auto";
    grep = "grep --color=auto";
    diff = "diff --color=auto";
    hm = "vim ~/.config/home-manager";
    hms = "home-manager switch";
  };

  # Powerline bash prompt line
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
    tmux = {
      enableShellIntegration = true;
    };
  };

  # Preview files with bat.
  programs.bat.enable = true;

  programs = {
    git = {
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

    gh.enable = true; # Manage github cli.

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
