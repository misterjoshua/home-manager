{ stdenv, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      granted = prev.granted.overrideAttrs (oldAttrs: {
        postInstall = ''
          cp $src/scripts/assume $out/bin/assume
          chmod +x $out/bin/assume
        '';
      });
    })
  ];

  home.packages = [pkgs.granted];
  
  home.shellAliases = {
    assume = "source ~/.nix-profile/bin/assume";
  };
}

