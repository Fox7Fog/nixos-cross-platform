{ inputs, lib, config, pkgs, desktop ? null, ... }:

{
  imports = [
    ../../shared
    ./linux.nix
  ];

  home = {
    username = "fox7fog";
    homeDirectory = "/home/fox7fog";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;

  # Set COSMIC cursor theme globally
  home.pointerCursor = {
    name = "Cosmic";
    size = 24;
    # Uncomment and set the correct package if available in pkgs
    # package = null; # No package set, will use system or manually installed cursor theme
  };

  # Configure virt-manager connection settings
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

}
