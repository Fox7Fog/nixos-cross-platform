{ config, pkgs, lib, desktop ? null, ... }:

{
  imports = lib.optionals (desktop == "hyprland") [
    ../../shared/desktop/linux/hyprland.nix
  ];

  # Linux-specific home configuration
  home.packages = with pkgs; [
    # Development tools (unstable for latest features)
    unstable.windsurf
    unstable.windsurf-next
    
    # Media players (unstable for latest codecs)
    unstable.mpv
    unstable.vlc
    
    # System tools
    unstable.docker-compose
  ];

  # Linux-specific session variables
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
