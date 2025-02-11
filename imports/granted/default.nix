{ stdenv, pkgs, lib, ... }:

let
  version = "0.36.3";
  sha256 = "sha256-fLnrc+Aek2bFrJfCCwI9HRAocokb3IlGZbjYzur7LHk=";
  vendorHash = "sha256-imArhe/TjrXv68ZF7moOcKjvxAvQzm7XfBkyWfwNJJs=";
in {
  home.packages = with pkgs; [
    (buildGoModule {
      pname = "assume";
      version = version;

      src = fetchFromGitHub {
        owner = "common-fate";
        repo = "granted";
        rev = "v${version}";
        sha256 = sha256;
      };

      vendorHash = vendorHash;

      subPackages = [ "cmd/granted" ];

      # Pass version to Go build
      ldflags = [
        "-X github.com/common-fate/granted/internal/build.Version=${version}"
        "-X github.com/common-fate/granted/internal/build.Commit=v${version}"
        "-X github.com/common-fate/granted/internal/build.Date=unknown"
        "-X github.com/common-fate/granted/internal/build.BuiltBy=nix"
      ];

      installPhase = ''
        mkdir -p $out/bin
        install -Dm755 $GOPATH/bin/granted $out/bin/assumego
        install -Dm755 $src/scripts/assume $out/bin/assume
      '';

      meta = with lib; {
        description = "The easiest way to access AWS accounts from the command line";
        homepage = "https://github.com/common-fate/granted";
        license = licenses.asl20;
        maintainers = with maintainers; [ ];
      };
    })
  ];
  
  home.shellAliases = {
    assume = "source ~/.nix-profile/bin/assume";
  };
}

