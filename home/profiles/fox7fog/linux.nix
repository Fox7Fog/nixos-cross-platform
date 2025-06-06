{ config, pkgs, lib, ... }:

{
  imports = [
    ../../shared/desktop/linux/hyprland.nix
  ];

  home.pointerCursor = {
    package = lib.mkForce pkgs.bibata-cursors;
    name = lib.mkForce "Bibata-Original-Classic";
    size = lib.mkForce 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Linux-specific home configuration
  home.packages = with pkgs; [
    # Packages from unstable channel
    (with unstable; [
      # Development tools
      windsurf
      vscode
      git
      gh
      docker-compose
      nodejs_20
      python3
      
      # Media and Graphics
      mpv
      vlc
      gimp
      inkscape
      obs-studio
      flameshot

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
      eza
      btop
      gparted
      pavucontrol
      blueman

      # File Management
      ranger
      pcmanfm
      xfce.thunar

      # Browsers
      firefox
      google-chrome

      # Office and Documents
      libreoffice
      evince
    ])
  ];

  # Linux-specific session variables
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
