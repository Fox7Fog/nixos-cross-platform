{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./languages
  ];
}
