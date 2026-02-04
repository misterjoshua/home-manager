{ lib, pkgs, ... }:
let
  # Convert nested attrset to LXC config format
  # e.g., { lxc.init.cmd = "foo"; } -> "lxc.init.cmd = foo"
  attrsToLxcConfig =
    attrs:
    let
      flattenAttrs =
        prefix: set:
        lib.concatLists (
          lib.mapAttrsToList (
            name: value:
            let
              key = if prefix == "" then name else "${prefix}.${name}";
            in
            if lib.isAttrs value then flattenAttrs key value else [ { inherit key value; } ]
          ) set
        );
      flattened = flattenAttrs "" attrs;
    in
    lib.concatMapStringsSep "\n" ({ key, value }: "${key} = ${toString value}") flattened;

  mkLxcPackage =
    {
      packages,
      config,
    }:
    let
      env = pkgs.buildEnv {
        name = "app";
        paths = packages;
      };
      pkgClosure = pkgs.closureInfo { rootPaths = packages; };
      metadataFile = pkgs.writeText "metadata.yaml" ''
        architecture: "x86_64"
      '';

      configFile = pkgs.writeText "config" (attrsToLxcConfig config);
    in
    pkgs.runCommand "app"
      {
        nativeBuildInputs = [
          pkgs.gnutar
          pkgs.gzip
        ];
      }
      ''
        set -euo pipefail

        # Create a basic rootfs
        mkdir -p $out/rootfs/{dev,proc,sys,tmp,run,etc,root}
        echo "root:x:0:0:root:/root:/bin/app" > $out/rootfs/etc/passwd
        echo "root:x:0:" > $out/rootfs/etc/group
        find $out/rootfs/ -type d -exec chmod 755 {} \;
        find $out/rootfs/ -type f -exec chmod 644 {} \;
        chmod 1777 $out/rootfs/tmp

        # Copy the closure's store paths to the rootfs
        while IFS= read -r p; do
          mkdir -p "$out/rootfs/$(dirname "$p")"
          cp -a "$p" "$out/rootfs$(dirname "$p")"
        done < ${pkgClosure}/store-paths

        # Splat the environment's bins and libs into the rootfs
        cp -r ${env}/. $out/rootfs/

        # Create metadata and config files
        cp ${metadataFile} $out/rootfs/metadata.yaml
        cp ${configFile} $out/rootfs/config

        # Tar the rootfs
        tar -C $out/rootfs -cJf $out/rootfs.tar.xz .
      '';
in
{
  inherit mkLxcPackage;
}
