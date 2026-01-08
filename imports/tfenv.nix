{
  config,
  pkgs,
  lib,
  ...
}:

let
  tfenv-package = pkgs.stdenv.mkDerivation rec {
    pname = "tfenv";
    version = "3.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "tfutils";
      repo = "tfenv";
      rev = "v${version}";
      sha256 = "sha256-2Fpaj/UQDE7PNFX9GNr4tygvKmm/X0yWVVerJ+Y6eks=";
    };

    installPhase = ''
      mkdir -p $out/opt/tfenv

      # Install everything to opt/tfenv (including CHANGELOG.md and other files)
      cp -r . $out/opt/tfenv/

      # Make all scripts executable
      chmod +x $out/opt/tfenv/bin/*
      chmod +x $out/opt/tfenv/libexec/* 2>/dev/null || true

      # Create bin directory and symlink the binaries
      mkdir -p $out/bin
      for script in $out/opt/tfenv/bin/*; do
        ln -s "$script" "$out/bin/$(basename $script)"
      done
    '';

    meta = with lib; {
      description = "Terraform version manager inspired by rbenv";
      homepage = "https://github.com/tfutils/tfenv";
      license = licenses.mit;
      platforms = platforms.unix;
    };
  };
in
{
  # Install tfenv package
  home.packages = [ tfenv-package ];

  # Set TFENV_ROOT environment variable
  home.sessionVariables = {
    TFENV_ROOT = "${config.home.homeDirectory}/.tfenv";
  };

  # Initialize .tfenv directory structure on activation
  home.activation.tfenvSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    TFENV_ROOT="${config.home.homeDirectory}/.tfenv"
    TFENV_SHARE="${tfenv-package}/opt/tfenv"

    $DRY_RUN_CMD mkdir -p "$TFENV_ROOT"
    $DRY_RUN_CMD ln -sfn "$TFENV_SHARE/lib" "$TFENV_ROOT/lib"
    $DRY_RUN_CMD ln -sfn "$TFENV_SHARE/libexec" "$TFENV_ROOT/libexec"
    $DRY_RUN_CMD ln -sfn "$TFENV_SHARE/CHANGELOG.md" "$TFENV_ROOT/CHANGELOG.md"

    # Also link other files that might be needed
    for file in "$TFENV_SHARE"/*.md "$TFENV_SHARE"/LICENSE "$TFENV_SHARE"/*.txt; do
      if [ -f "$file" ]; then
        $DRY_RUN_CMD ln -sfn "$file" "$TFENV_ROOT/$(basename "$file")" || true
      fi
    done
  '';
}
