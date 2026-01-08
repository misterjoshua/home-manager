{
  config,
  pkgs,
  lib,
  ...
}:

let
  nvmDir = ".nvm-nix";
in
{
  # Install nvm (Node Version Manager)
  programs.bash.initExtra = lib.mkAfter ''
    # Integrate with nvm if available. 
    export NVM_DIR="$HOME/${nvmDir}"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  '';

  home.file."${nvmDir}" = {
    source = pkgs.stdenv.mkDerivation {
      name = "nvm";
      version = "home-manager";

      src = pkgs.fetchFromGitHub {
        owner = "nvm-sh";
        repo = "nvm";
        rev = "v0.40.1";
        sha256 = "sha256-PMeFHjJ3qcphXV8MceZwleOgJrDfEeS3m/ZGvKlWbeg=";
      };

      buildCommand = ''
        mkdir -p $out
        cp -r $src/* $out
        rm -rf $out/alias $out/.cache $out/versions
        ln -s ${config.home.homeDirectory}/.local/state/nvm.aliases $out/alias
        ln -s ${config.home.homeDirectory}/.local/state/nvm.cache $out/.cache
        ln -s ${config.home.homeDirectory}/.local/state/nvm.versions $out/versions
      '';
    };
  };

  # Create required NVM state directories
  home.activation.createNvmDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/.local/state/nvm.aliases"
    mkdir -p "${config.home.homeDirectory}/.local/state/nvm.cache"
    mkdir -p "${config.home.homeDirectory}/.local/state/nvm.versions"
  '';
}
