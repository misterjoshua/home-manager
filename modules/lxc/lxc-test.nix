{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      lxcLib = import ./_lib.nix { inherit lib pkgs; };
      lxcApp = pkgs.writeShellApplication {
        name = "init";
        runtimeInputs = [
          pkgs.dropbear
          pkgs.busybox
        ];
        text = ''
          set -euo pipefail
          udhcpc -i eth0 -n -q
          ip route
          ip addr
          sh
        '';
      };
    in
    {
      packages.lxc-test = lxcLib.mkLxcPackage {
        packages = [ lxcApp ];
        config = {
          lxc = {
            init.cmd = "${lxcApp}/bin/init";
          };
        };
      };
    };
}
