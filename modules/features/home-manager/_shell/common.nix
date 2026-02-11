{ pkgs, ... }:
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    _1password-cli
    pipx
    apg
    # Shells
    powershell
    # Language Servers
    lua-language-server
    vim-language-server
    nixd
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
    ripgrep
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

  home.sessionVariables = {
    PATH = "$PATH:$HOME/.config/composer/vendor/bin:$HOME/.local/bin";
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
    tmux.enableShellIntegration = true;
  };

  # Preview files with bat.
  programs.bat.enable = true;
}
