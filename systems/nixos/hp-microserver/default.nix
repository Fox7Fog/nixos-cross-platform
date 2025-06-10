{
  imports = [
    ./hardware.nix
    ../common/wm/hyprland
    ../common/wm/hyprland/hardware-intel.nix
  ];

  networking.hostName = "hp-microserver";
  time.timeZone = "Etc/UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.fox7fog = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "docker" ];
  };

  # Server-specific services
  virtualisation.docker.enable = true;
  services = {
    openssh.enable = true;
    smartd.enable = true;  # For HDD health monitoring
    zfs.autoScrub.enable = true;  # If using ZFS
    
    # Temperature monitoring
    lm_sensors.enable = true;
    fancontrol.enable = true;
  };

  # Additional server packages
  environment.systemPackages = with pkgs; [
    smartmontools  # For disk health monitoring
    lm_sensors    # For temperature monitoring
    htop
    iotop
    iftop
  ];

  system.stateVersion = "23.11";
}
