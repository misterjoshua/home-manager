{ self, ... }:
{
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      imports = [
        self.modules.nixos.nix
        self.modules.nixos.gen-identity
      ];

      nixpkgs.config.allowUnfree = true;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;

      networking.wireless.enable = true;
      networking.networkmanager.enable = true;

      time.timeZone = "America/Edmonton";
      i18n.defaultLocale = "en_CA.UTF-8";

      services.avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          addresses = true;
          workstation = true;
        };

        openFirewall = true;
      };

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users = {
        defaultUserShell = pkgs.bashInteractive;
      };

      programs.bash.enable = true;
      environment.systemPackages = with pkgs; [
        vim
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      programs.mtr.enable = true;
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      system.stateVersion = "25.11";
    };
}
