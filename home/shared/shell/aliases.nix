{ config, pkgs, lib, ... }:

{
  home.shellAliases = {
    # Common aliases
    ll = "ls -la";
    la = "ls -la";
    l = "ls -l";
    
    # Git aliases
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git log --oneline";
    
    # Nix aliases
    nrs = "sudo nixos-rebuild switch --flake .";
    nrt = "sudo nixos-rebuild test --flake .";
    hms = "home-manager switch --flake .";
    
    # Removed macOS alias; Linux only
    
    # Development shells
    dev-eth = "nix develop .#ethereum";
    dev-sol = "nix develop .#solana";
    dev-rust = "nix develop .#web-rust";
    dev-py = "nix develop .#python";
    dev-go = "nix develop .#go";
  };
}
