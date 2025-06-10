{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "fox7fog";
    userEmail = "fox7fog@protonmail.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      push.default = "simple";
      pull.rebase = true;
      
      core = {
        editor = "nvim";
        autocrlf = false;
      };
      
      merge = {
        conflictstyle = "diff3";
      };
      
      diff = {
        colorMoved = "default";
      };
    };
    
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
      graph = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
    
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
      };
    };
  };
}
