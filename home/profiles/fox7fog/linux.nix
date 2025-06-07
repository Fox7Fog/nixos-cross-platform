{ config, pkgs, lib, unstable, ... }:

{
  imports = [
    ../../shared/desktop/linux/hyprland.nix
    ../../shared/ssh.nix
  ];

  home.pointerCursor = {
    # package = lib.mkForce pkgs.bibata-cursors;
    package = lib.mkForce pkgs.adwaita-icon-theme;
    name = lib.mkForce "Adwaita";
    size = lib.mkForce 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Linux-specific home configuration
  home.packages = with unstable; [
  # Development tools
  windsurf
  vscode
  docker-compose
  nodejs_20
  python3
  alacritty

  # Media and Graphics
  mpv
  vlc
  gimp
  inkscape
  obs-studio
  flameshot
  persepolis
  clipgrab

  # Communication
  discord
  telegram-desktop
  thunderbird

  # System and Utilities
  htop
  neofetch
  wget
  curl
  unzip
  zip
  ripgrep
  fd
  fzf
  bat
  btop
  gparted
  pavucontrol
  blueman
  qt6.qtbase
  qt6ct

  # File Management
  ranger

  # Browsers
  google-chrome
  brave
  cosmic-files

  # Office and Documents
  libreoffice
  evince
];

  # Linux-specific session variables
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_RENDERER = "vulkan";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    QT_QPA_PLATFORM= "wayland";
    QT_QPA_PLATFORMTHEME= "qt6ct";
    QT6CT_PLATFORMTHEME= "qt6ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION= "1";
  };
}
