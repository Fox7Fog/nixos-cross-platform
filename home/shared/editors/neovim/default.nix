{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    # package = pkgs.neovim;
    
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    extraConfig = ''
      " Basic settings
      set number
      set relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set autoindent
      set smartindent
      
      " Search settings
      set ignorecase
      set smartcase
      set hlsearch
      set incsearch
      
      " UI settings
      set termguicolors
      set signcolumn=yes
      set updatetime=300
    '';
    
    plugins = with pkgs.vimPlugins; [
      # Essential plugins
      nvim-treesitter.withAllGrammars
      telescope-nvim
      nvim-lspconfig
      
      # UI
      lualine-nvim
      nvim-web-devicons
      
      # Git
      gitsigns-nvim
      
      # File explorer
      nvim-tree-lua
      
      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      
      # Snippets
      luasnip
      cmp_luasnip
      
      # Language support
      rust-tools-nvim
      typescript-nvim
    ];
  };

  # Link the nvim configuration files (init.lua, lua/, etc.)
  # to ~/.config/nvim
  # Assumes your nvim configuration files are now located in
  # <flake-root>/home/shared/config/nvim/
  xdg.configFile."nvim" = {
    source = ../../config/nvim; # Relative path from this file
    recursive = true; # Ensure the whole directory is linked
  };
}
