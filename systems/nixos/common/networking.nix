{ config, pkgs, lib, ... }:

{
  networking = {
    useDHCP = false;
    interfaces = {
    };
  };
}
