{ ... }:
let
  mkGenIdentityCall =
    {
      pkgs,
      identityName,
      outDir,
    }:
    let
      script = pkgs.writeShellScript "gen-identity-activation" ''
        PATH="${pkgs.openssh}/bin:${pkgs.age}/bin:${pkgs.bash}/bin:$PATH" \
        IDENTITY_NAME="${identityName}@$(${pkgs.hostname}/bin/hostname)" \
        OUT_DIR="${outDir}" \
        bash ${./gen-identity.sh} id_ed25519 age
      '';
    in
    "${script}";
in
{
  flake.modules.homeManager.gen-identity =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      genIdentityCall = mkGenIdentityCall {
        inherit pkgs;
        identityName = config.home.username;
        outDir = "${config.home.homeDirectory}/.config/identity";
      };
    in
    {
      home.activation.gen-identity = lib.hm.dag.entryAfter [ "writeBoundary" ] genIdentityCall;
    };

  flake.modules.nixos.gen-identity =
    { pkgs, config, ... }:
    let
      genIdentityCall = mkGenIdentityCall {
        inherit pkgs;
        identityName = config.networking.hostName;
        outDir = "/etc/identity";
      };
    in
    {
      systemd.services.gen-identity = {
        description = "Generate identity";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = genIdentityCall;
        };
      };
    };
}
