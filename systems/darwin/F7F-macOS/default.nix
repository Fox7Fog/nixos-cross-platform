{ config, pkgs, lib, inputs, outputs, ... }:

{
  # System identity
  networking.hostName = "F7F-macOS";
  networking.computerName = "F7F-macOS";
  
  # Nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 7d";
    };
  };

  # Core system packages (BSD-compatible when possible)
  environment.systemPackages = with pkgs; [
    # BSD coreutils (more compatible with Darwin)
    coreutils
    findutils
    
    # Essential tools
    curl
    wget
    git
    tree
    htop
    
    # Compression
    zip
    unzip
    p7zip
    
    # Network tools
    openssh
    rsync
  ];

  # System preferences
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      showhidden = true;
      mru-spaces = false;
    };
    
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
    };
  };

  # Homebrew integration
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    
    # Homebrew taps
    taps = [
      "homebrew/cask-fonts"
    ];
    
    # GUI applications via Homebrew
    casks = [
      "firefox"
      "visual-studio-code"
      "docker"
    ];
    
    # Mac App Store apps
    masApps = {
      "Xcode" = 497799835;
    };
  };

  # Services
  services.nix-daemon.enable = true;
  
  # Darwin state version
  system.stateVersion = 4;
}
