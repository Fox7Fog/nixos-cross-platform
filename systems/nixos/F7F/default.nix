{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./services.nix
  ];

  # System identity
  networking.hostName = "F7F";
  
  # Nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Boot configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Time and locale
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  # Core system packages (stable)
  environment.systemPackages = with pkgs; [
    # Core utilities
    coreutils
    findutils
    gnugrep
    gnused
    gawk
    
    # Build tools
    gcc
    gnumake
    cmake
    pkg-config
    
    # System tools
    wget
    curl
    git
    htop
    tree
    
    # Audio codecs and multimedia
    ffmpeg

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    
    # Compression
    zip
    unzip
    p7zip
    
    # Network tools
    openssh
    rsync
  ];

  # NixOS state version
  system.stateVersion = "25.05";
}
