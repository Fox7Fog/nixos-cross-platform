{ config, lib, ... }: {
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/ed_25519_fox7fog";
        identitiesOnly = true;
        user = "git";
      };
    };
  };

  # Ensure the SSH agent is running
  services.ssh-agent.enable = true;

  # Ensure SSH directory exists
  home.file.".ssh/.keep" = {
    text = "";
  };
  
  # Note: SSH keys are now managed by sops-nix
  # See /home/fox7fog/.dotfiles/nixos-cross-platform/modules/sops.nix
}
