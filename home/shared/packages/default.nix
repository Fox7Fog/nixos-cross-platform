{ config, pkgs, lib, ... }:

{
  imports = [
    ./common.nix
    ./development.nix
  ];
}
