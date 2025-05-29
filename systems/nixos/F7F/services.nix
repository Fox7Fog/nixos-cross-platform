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

  # Enable Hyprland (from unstable)
  programs.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
  };
}
