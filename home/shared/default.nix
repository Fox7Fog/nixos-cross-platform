{ config, pkgs, lib, ... }:

{
  imports = [
    ./shell
    ./editors
    ./terminals
    ./development
    ./packages
  ];
}
