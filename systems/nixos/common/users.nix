{ config, pkgs, lib, ... }:

{
  users.users.fox7fog = {
    isNormalUser = true;
    description = "fox7fog";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.bash;
  };
}
