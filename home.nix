{ pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "josh";
  home.homeDirectory = "/home/josh";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./imports/granted
    ./imports/kube.nix
    ./imports/neovim
    ./imports/nvm.nix
    ./imports/ollama
    ./imports/scripts
    ./imports/terminus.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Php
    php83
    php83Packages.composer
    ddev
    # Rust
    rustup
    # Golang
    go
    gopls
    delve
    # Protocol Buffers
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
    # Java
    jdk
    maven
    gradle
    # Powershell
    powershell
    # Lua
    lua-language-server
    # Nix
    nixd
    # Vim
    vim-language-server
    # Git
    git
    git-lfs
    git-crypt
    gh
    # Ansible
    ansible
    ansible-lint
    # Terraform
    terraform
    # Cloud
    awscli2
    azure-cli
    steampipe
    # Comms
    irssi
    # CLI utils
    jq
    yq
    tree
    htop
    tmux
    direnv
    graphviz
    # Network
    curl
    mtr
    traceroute
    netcat
    nmap
    httpie
    wget
    ngrok
    cloudflared
    host
    dig
    # Reports
    steampipe

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
  };
  
  # Powerline bash prompt line
  programs.powerline-go.enable = true;
  programs.powerline-go.settings = {
    mode = "flat"; # flat so it works in more terminals
  };

  # FZF for fuzzy search of files and autocomplete.
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--height 75%" "--min-height 10" "--border"
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

  # Manage git's config.
  programs.git = {
    enable = true;
    userEmail = "joshkellendonk@gmail.com";
    userName = "Josh Kellendonk";
    lfs.enable = true;
    extraConfig.pull.rebase = true;
  };
}
