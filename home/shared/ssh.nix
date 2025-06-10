{ config, lib, ... }: {
  programs.ssh = {
    enable = true;
    # Specifies the SSH identity file to be used for authentication.
    # Ensure this key exists or is generated.
    identityFile = "~/.ssh/id_ed25519";
    addKeysToAgent = "yes";
    matchBlocks = {
      "github.com" = {
        # identityFile = "~/.ssh/ed_25519_username"; # Removed to use global
        identitiesOnly = true;
        user = "git";
      };
      "gitlab.com" = {
        # identityFile = "~/.ssh/id_ed25519"; # Example, if needed
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
  
}
