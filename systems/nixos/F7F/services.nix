{ config, pkgs, lib, ... }:

{
  # Display manager and desktop
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = false;
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true;

  # Network
  networking.networkmanager.enable = true;

  # Printing
  services.printing.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Docker (from unstable)
  virtualisation.docker = {
    enable = true;
    package = pkgs.unstable.docker;
  };

  # Copy custom Hyprland config to /etc/hyprland-custom
  # To use your custom config, manually symlink or copy /etc/hyprland-custom to ~/.config/hypr
  environment.etc."hyprland-custom".source = "/home/fox7fog/.dotfiles/linux-config/.config/hypr";

  # Enable Hyprland (from unstable)
  programs.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
  };


  # Example: Secure cascade agent service
  systemd.services.cascade = {
    description = "Cascade Agent (placeholder)";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.coreutils}/bin/true"; # Placeholder command
      DynamicUser = true; # creates transient user, avoids missing user error
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      CapabilityBoundingSet = [ ];
    };
  };
  # Production-grade: Disable IPv6 at the kernel level
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.disable_ipv6" = 1;
    "net.ipv6.conf.default.disable_ipv6" = 1;
  };
}
