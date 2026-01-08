{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Install Terminus CLI tool for Pantheon
  home.packages = [
    (pkgs.stdenv.mkDerivation {
      name = "terminus";
      version = "3.6.1";

      src = pkgs.fetchurl {
        url = "https://github.com/pantheon-systems/terminus/releases/download/3.6.1/terminus.phar";
        sha256 = "sha256-nO/LjV8JUzNBc9g3zvlDqLiK/sF/rkMnwVJxv8nD3FA="; # You'll need to add the correct hash after first attempt
      };

      dontUnpack = true;

      nativeBuildInputs = [ pkgs.php ];

      installPhase = ''
        mkdir -p $out/bin
        cp $src $out/bin/terminus
        chmod +x $out/bin/terminus
      '';

      meta = with lib; {
        description = "Pantheon's Command-line Interface";
        homepage = "https://github.com/pantheon-systems/terminus";
        license = licenses.mit;
        platforms = platforms.all;
      };
    })
  ];
}
