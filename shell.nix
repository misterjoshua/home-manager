{ pkgs, ... }:
pkgs.mkShell {
  packages = with pkgs; [ nixfmt ];
}
