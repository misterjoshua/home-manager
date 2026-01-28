{ self, ... }:
{
  flake.modules.nixos.htpc =
    { pkgs, ... }:
    {
      imports = [
        self.modules.nixos.nix
        self.modules.nixos.base
      ];

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

      systemd.sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
        AllowHybridSleep=no
        AllowSuspendThenHibernate=no
      '';

      services.xserver = {
        enable = true;
        windowManager.openbox.enable = true;
      };

      # Install HTPC apps and menu tools
      environment.systemPackages = with pkgs; [
        kodi
        plex-desktop
        rofi # Launcher menu
      ];

      services.displayManager = {
        autoLogin = {
          enable = true;
          user = "htpc";
        };
      };

      # User for the HTPC.
      users.users.htpc = {
        isNormalUser = true;
        description = "HTPC";
        extraGroups = [
          "video"
          "audio"
          "networkmanager"
          "input"
        ];
      };
    };
}
