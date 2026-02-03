{ self, ... }:
{
  flake.modules.nixos.workstation =
    { pkgs, ... }:
    {
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;

      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      services.printing.enable = true;
      programs.firefox.enable = true;
    };
}
