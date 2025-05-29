{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Core utilities
    zoxide
    ripgrep
    fd
    bat
    eza
    fzf
    jq
    
    # Archive tools
    zip
    unzip
    p7zip
    
    # Network tools
    wget
    curl
    
    # System monitoring
    htop
    btop
    
    # File management
    tree
    
    # Fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];
}
