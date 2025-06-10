{
  imports = [
    ./hardware.nix
    ../common/wm/hyprland
    ../common/wm/hyprland/hardware-intel.nix
  ];

  networking.hostName = "dell-optiplex";
  time.timeZone = "Etc/UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.fox7fog = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
  };

  services.openssh.enable = true;
  system.stateVersion = "23.11";
}
