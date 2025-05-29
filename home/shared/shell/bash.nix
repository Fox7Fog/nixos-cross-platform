{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    bashrcExtra = ''
      # Set default editor
      export EDITOR=nvim
      
      # Platform-specific settings
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        # macOS-specific bash settings
        export PATH="/opt/homebrew/bin:$PATH"
      ''}
      
      ${lib.optionalString pkgs.stdenv.isLinux ''
        # Linux-specific bash settings
        # Wayland clipboard integration
        if command -v wl-copy &> /dev/null; then
          alias pbcopy='wl-copy'
          alias pbpaste='wl-paste'
        fi
      ''}
    '';
    
    historyControl = [ "ignoredups" "ignorespace" ];
    historySize = 10000;
  };
}
