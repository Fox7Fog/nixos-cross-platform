# Common Hyprland configuration for all machines
{ config, lib, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Required packages for Hyprland
  environment.systemPackages = with pkgs; [
    # Core utilities
    kitty    # Terminal
    wofi     # Application launcher
    waybar   # Status bar
    swaylock # Screen locker
    swayidle # Idle management
    grim     # Screenshot utility
    slurp    # Screen area selection
    wl-clipboard # Wayland clipboard utilities
    mako     # Notification daemon
    
    # System tray utilities
    networkmanagerapplet
    blueman
    
    # Theme-related
    gtk3
    qt5.qtwayland
    qt6.qtwayland
    
    # Audio controls
    pavucontrol
    pamixer
  ];

  # Enable common services
  services = {
    # For screen locking
    swayidle.enable = true;
    
    # For notifications
    mako.enable = true;
    
    # DBus - needed by many Wayland apps
    dbus.enable = true;
    
    # Bluetooth
    blueman.enable = true;
    
    # For GTK application settings
    gvfs.enable = true;
    
    # Thumbnail support
    tumbler.enable = true;
  };

  # XDG Portal - Screen sharing, file picking
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  # Enable sound
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Environment variables for Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Electron apps: use Wayland
    MOZ_ENABLE_WAYLAND = "1"; # Firefox: use Wayland
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];
}
