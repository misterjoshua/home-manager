{ pkgs, ... }:
{
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
    dig.host
  ];

  # home.sessionVariables = {
  #   PATH = "$PATH:$HOME/.config/composer/vendor/bin:$HOME/.local/bin";
  # };
}
