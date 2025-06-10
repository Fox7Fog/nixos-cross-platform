{ config, pkgs, lib, ... }:

{
  imports = [
    ./neovim
    emacs
  ];
}
