{
  flake.modules.nixos.media-server =
    { ... }:
    {
      services.plex.enable = true;
    };
}
