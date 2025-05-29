{ config, pkgs, lib, ... }:

{
  # macOS-specific home configuration
  home.packages = with pkgs; [
    # BSD-compatible coreutils
    coreutils
    findutils
    gnused
    gawk
    
    # Development tools (minimal Linux ports, prefer native)
    unstable.docker-compose
    
    # Media (when needed)
    unstable.mpv  # Only if no good native alternative
  ];

  # macOS-specific session variables
  home.sessionVariables = {
    PATH = "$PATH:/opt/homebrew/bin";
  };

  # macOS application linking
  home.activation.copyApplications = lib.mkAfter ''
    echo "Creating ~/Applications/NixApps directory..."
    mkdir -p ~/Applications/NixApps
    
    echo "Linking Nix-installed applications..."
    for app in $(find ~/.nix-profile/Applications -type d -name "*.app" -depth 1 2>/dev/null); do
      appname=$(basename "$app")
      echo "Linking $appname"
      ln -sf "$app" ~/Applications/NixApps/
    done
  '';
}
