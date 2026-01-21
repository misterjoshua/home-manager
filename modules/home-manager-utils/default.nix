rec {
  standaloneHome = import ./standalone-home.nix;
  nixosUsers = import ./nixos-users.nix;

  override = defaultArgs: {
    standaloneHome = args: standaloneHome (defaultArgs // args);
    nixosUsers = args: nixosUsers (defaultArgs // args);
    override = args: override (defaultArgs // args);
  };
}
