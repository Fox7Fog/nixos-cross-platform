require("lazy").setup({
  lockfile = vim.fn.stdpath("cache") .. "/lazy-lock.json",
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.svelte" },
    { import = "lazyvim.plugins.extras.lang.vue" },
  },
  defaults = {
    version = false,
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = false,
  },
  lockfile = vim.fn.stdpath("cache") .. "/lazy-lock.json",
})
