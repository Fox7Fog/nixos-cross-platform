{ config, pkgs, lib, ... }:

{
  users.users.fox7fog = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "networkmanager"
      "libvirtd"
      "kvm"
      "input"
      "disk"
    ];
  };
}
