{ config, pkgs, lib, ... }:

{
  imports = [
    ./rust.nix
    ./python.nix
    ./javascript.nix
  ];
}
