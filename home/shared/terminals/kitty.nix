{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      
      # Theme
      background = "#1e1e2e";
      foreground = "#cdd6f4";
      
      # Cursor
      cursor = "#f5e0dc";
      cursor_text_color = "#1e1e2e";
      
      # Selection
      selection_background = "#585b70";
      selection_foreground = "#cdd6f4";
      
      # Window
      window_padding_width = 8;
      hide_window_decorations = "no";
      
      # Tab bar
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
    
    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
    };
  };
}
