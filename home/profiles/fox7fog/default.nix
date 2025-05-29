{ inputs, outputs, lib, config, pkgs, desktop ? null, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in {
  imports = [
    ../../shared
  ] ++ lib.optionals isLinux [
    ./linux.nix
  ] ++ lib.optionals isDarwin [
    ./darwin.nix
  ];

  home = {
    username = "fox7fog";
    homeDirectory = if isDarwin then "/Users/fox7fog" else "/home/fox7fog";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
}
