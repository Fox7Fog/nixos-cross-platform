{ config, pkgs, lib, unstable, ... }:

{
  imports = [
    ../../shared/desktop/linux/hyprland.nix
    ../../shared/ssh.nix
    ../../shared/hyprland.nix
  ];

  home.pointerCursor = {
    package = lib.mkForce pkgs.adwaita-icon-theme;
    name = lib.mkForce "Adwaita";
    size = lib.mkForce 24;
    gtk.enable = true;
    x11.enable = true;
    # Ensure this is comprehensive for your Linux setup
  };

  # Configure virt-manager connection settings (moved from default.nix)
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Enable dconf (required for GTK theme settings)
  dconf.enable = true;

  # GTK theme settings
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };

  # QT theme settings
  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
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
    EDITOR = "nvim";
    TERMINAL = "kitty";
    BROWSER = "firefox";
  };
}
