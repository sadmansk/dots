return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },

  config = function(_, opts)
    require("snacks").setup(opts)

    -- lazygit
    if vim.fn.executable("lazygit") == 1 then
      local git_root = function()
        return vim.fn.systemlist("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel")[1]
      end
      vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit({ cwd = git_root() }) end, { desc = "Lazygit (Root Dir)" })
      vim.keymap.set("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
    end
  end,
}
