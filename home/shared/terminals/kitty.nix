{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.unstable.kitty else pkgs.kitty;
    
    font = {
      name = "JetBrainsMono Nerd Font";
      size = if pkgs.stdenv.isDarwin then 14 else 12;
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
      hide_window_decorations = if pkgs.stdenv.isDarwin then "titlebar-only" else "no";
      
      # Tab bar
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
    
    keybindings = {
      "cmd+t" = lib.mkIf pkgs.stdenv.isDarwin "new_tab";
      "cmd+w" = lib.mkIf pkgs.stdenv.isDarwin "close_tab";
      "ctrl+shift+t" = lib.mkIf pkgs.stdenv.isLinux "new_tab";
      "ctrl+shift+w" = lib.mkIf pkgs.stdenv.isLinux "close_tab";
    };
  };
}
