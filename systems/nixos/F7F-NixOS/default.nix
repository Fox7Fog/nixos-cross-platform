{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./services.nix
    ./services.nix
    ./polkit.nix
  ];


  # System identity
  networking.hostName = "F7F-NixOS";
  
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
  time.timeZone = "Etc/UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # Core system packages (stable)
  environment.systemPackages = with pkgs; [
    gnupg
    # Core utilities
    coreutils
    findutils
    gnugrep
    gnused
    gawk
    
    # System management
    gparted
    
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

    # GStreamer packages
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
    rustdesk
  ];

  # Configure OpenSSH server settings.
  # This configuration enhances security by:
  # - Disabling root login.
  # - Disabling password-based authentication (requires public key authentication).
  services.openssh = {
    enable = true;
    allowSFTP = false; # Set to true if SFTP access is needed.
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    # Specifies the file(s) containing public keys for user authentication.
    # Ensure this file (e.g., /etc/ssh/authorized_keys_only) is populated
    # with the public keys of users who should have access.
    authorizedKeysFiles = [ "/etc/ssh/authorized_keys_only" ];
    # For additional sshd_config options, use the 'extraConfig' attribute.
    # Example:
    # extraConfig = ''
    #   # Allow only specific users
    #   # AllowUsers user1 user2
    #   #
    #   # Set custom client alive settings
    #   # ClientAliveInterval 600
    #   # ClientAliveCountMax 0
    # '';
  };

  # NixOS state version
  system.stateVersion = "25.05";
}
