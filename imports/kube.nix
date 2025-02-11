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
    source <(velero completion bash)
    complete -o default -F __start_velero v

    function pxctl() {
      if [ -z "$PX_POD" ]; then
        export PX_POD=$(kubectl -n kube-system get pods -lname=portworx -o jsonpath='{.items[0].metadata.name}')
      fi

      kubectl -n kube-system exec -it "$PX_POD" -- /opt/pwx/bin/pxctl "$@"
    }
  '';

  # Create symlinks for kubectl plugins
  home.file = {
    ".local/bin/kubectl-ns".source = lib.mkForce "${pkgs.kubectx}/bin/kubens";
    ".local/bin/kubectl-ctx".source = lib.mkForce "${pkgs.kubectx}/bin/kubectx";
  };
}