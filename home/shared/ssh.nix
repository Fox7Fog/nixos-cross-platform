{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/ed_25519_fox7fog";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
    };
  };
}
