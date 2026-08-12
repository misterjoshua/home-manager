{ pkgs, lib, ... }:
let
  # Upstream installs these under bash_completion.d/, which bash-completion
  # does not auto-load — source them explicitly.
  cephCompletions = "${pkgs.ceph-client}/share/bash-completion/completions/bash_completion.d";
in
{
  # Ceph client CLIs: ceph, rados, rbd, ceph-authtool, etc.
  home.packages = with pkgs; [
    ceph-client
    kubectl-rook-ceph
  ];

  # Expose rook-ceph as a kubectl plugin alongside the other kube helpers.
  home.file = {
    ".local/kube.nix/kubectl-rook-ceph".source =
      lib.mkForce "${pkgs.kubectl-rook-ceph}/bin/kubectl-rook-ceph";
  };

  programs.bash.initExtra = ''
    source ${cephCompletions}/ceph
    source ${cephCompletions}/rados
    source ${cephCompletions}/rbd
    source ${cephCompletions}/radosgw-admin
  '';
}
