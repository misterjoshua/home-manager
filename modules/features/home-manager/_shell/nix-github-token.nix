{
  config,
  lib,
  ...
}:
let
  tokenFile = "${config.home.homeDirectory}/.config/nix/access-tokens.conf";
  gh = "${config.programs.gh.package}/bin/gh";
in
{
  # Home Manager owns ~/.config/nix/nix.conf (a read-only store symlink), so the
  # GitHub token lives in a separate unmanaged file. `!include` ignores a missing
  # file, so hosts where gh is not logged in still get a valid nix.conf.
  nix.extraOptions = "!include ${tokenFile}";

  # Nix's `github:` fetcher does not use git's credential helper; it needs the
  # token in access-tokens. Reuse the gh login rather than managing a second PAT.
  home.activation.nixGithubToken = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    token="$(${gh} auth token -h github.com 2>/dev/null || true)"
    if [ -n "$token" ]; then
      run mkdir -p "$(dirname ${lib.escapeShellArg tokenFile})"
      if [ -z "''${DRY_RUN:-}" ]; then
        (
          umask 077
          tmp="$(mktemp "${tokenFile}.XXXXXX")"
          printf 'access-tokens = github.com=%s\n' "$token" > "$tmp"
          mv -f "$tmp" ${lib.escapeShellArg tokenFile}
        )
      else
        echo "Would write GitHub token to ${tokenFile}"
      fi
    else
      echo "gh is not logged in to github.com; skipping ${tokenFile}." \
        "Run 'gh auth login' then 'home-manager switch' to enable private github: flake inputs."
    fi
  '';
}
