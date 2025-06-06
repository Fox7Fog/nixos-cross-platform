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
}
