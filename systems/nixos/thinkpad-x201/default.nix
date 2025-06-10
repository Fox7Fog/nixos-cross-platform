{
  imports = [
    ./hardware.nix
    ../common/wm/hyprland
    ../common/wm/hyprland/hardware-intel.nix
  ];

  networking.hostName = "thinkpad-x201";
  time.timeZone = "Etc/UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.fox7fog = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
  };

  # ThinkPad-specific packages
  environment.systemPackages = with pkgs; [
    acpi
    tlp
    powertop
  ];

  # Enable TLP for better battery life
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  services.openssh.enable = true;
  system.stateVersion = "23.11";
}
