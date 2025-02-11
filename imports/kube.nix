{ config, pkgs, lib, ... }:

{
  # Kubectl
  programs.kubecolor = {
    enable = true; 
    enableAlias = true;
  };


  # Plugins
  home.packages = with pkgs; [
    kubectl
    kubectx
    velero
  ];

  # Add handy kubectl aliases
  programs.bash.shellAliases = {
    k = "kubectl";
  };

  # Enable kubectl completions
  programs.bash.initExtra = ''
    source <(kubectl completion bash)
    complete -o default -F __start_kubectl k
  '';

  # Create symlinks for kubectl plugins
  home.file = {
    ".local/bin/kubectl-ns".source = lib.mkForce "${pkgs.kubectx}/bin/kubens";
    ".local/bin/kubectl-ctx".source = lib.mkForce "${pkgs.kubectx}/bin/kubectx";
  };
}